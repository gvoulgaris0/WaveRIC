%% findSwellRWIC.m (calls internal function: swellpeak.m)
%  Function to calculate the swell peak frequency (fswell), and
%  swell Doppler energy ratio (Eswell) and integrated energy ratio (Rswell)
%%
function [fswell,Eswell,Rswell] = findSwellRWIC(freq,PXY,fc,swplot)
%% [fswell,Eswell,Rswell] = findSwellRWIC(freq,fradar,PXY,swplot)
% 
% This function calculates the swell peak frequency (fswell), and
% swell Doppler energy ratio (Eswell) and integrated energy ratio (Rswell)
%
%% Input
%    freq        - Array of Doppler Spectral frequency in Hz
%    fradar      - Radar operating frequency (in MHz)
%    PXY(1:freq) - Array of Spectral Energy (in dB), do not send arrays of NaN
%    fc          - Don't find swell peaks above this frequency (Hz), usually the same as fc
%    swplot      - >0 if you want a plot [optional, default no plot]
%
%% Output
%    fswell      - Swell frequency (Hz)
%    Eswell      - Normalized by 1st order peak Doppler energy (at swell range)(Hz^-1)
%    Rswell      - Normalized by 1st order integrated Doppler energy (at swell range) (no units)
%
%% Uses
% ConditionDopRWIC.m, swell_peak.m, trapz.m
%
%% Copyright 2019 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
% This file is part of RadarWIC.
%
% RadarWIC is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%%
if nargin<4
    swplot=-10;
end
% call common functions, Noise identification, Bragg peak identification,
% etc. See inside function for more information.
ConditionDopRWIC;
%% Swell - peak identification
% for peaks 1 -4 from lowest f to highest, so 1 is negative outside
% swell peak, and 4 is positive outside swell peak
% 1 = m1(m) = -1, m2(m') = -1
% 2 = m1(m) = -1, m2(m') = 1
% 3 = m1(m) = 1, m2(m') = -1
% 4 = m1(m) = 1, m2(m') = 1
% this notation is followed here for f1-4, E1-4 and S1-4 where
% f1 is swell peak freq, E1 is energy at this frequency
% and S1 is the integral of this swell peak energy (Wang/Lipa)
[f1,E1,S1,si1] = swell_peak(freq,PXY,fn-fc,fn-Lowfns ); % 2nd order to the left (l) of Neg 1st
[f2,E2,S2,si2] = swell_peak(freq,PXY,fn+Lowfns ,fn+fc); % 2nd order to the right (r) of Neg 1st
[f3,E3,S3,si3] = swell_peak(freq,PXY,fp-fc,fp-Lowfps ); % 2nd order to the left (l) of Pos 1st
[f4,E4,S4,si4] = swell_peak(freq,PXY,fp+Lowfps ,fp+fc); % 2nd order to the right (r) of Pos 1st

% plot
if swplot>0
    plot_swell;
end
dfn = f2-f1; % difference between negative swell peaks, using ^4 Sf weighting (Zaid method)
dfp = f4-f3; % difference between positive swell peaks

%% Swell - as in Alattabi et al 2019
% fswell (Hz) swell frequency
% Eswell (Hz^-1) Peak energy ratio to integrated Bragg peak
% Rswell (no units) integral of swell peak ratio to integrated Bragg peak)

% if ~isnan(dfn) && ~isnan(dfp)
    if dom == 1  &&  S1P < S1N/10^(peak_diff_db/10)     % Neg. side Peak
        fswell = dfn/2;
        Eswell = (E1 + E2) / S1N;
        Rswell = (S1 + S2) / S1N;
    elseif dom == 1  &&  S1P > S1N*10^(peak_diff_db/10) % Pos. side Peak
        fswell = dfp/2;
        Eswell = (E3 + E4) / S1P;
        Rswell = (S3 + S4) / S1P;
    else                   % Use both Peaks (within peak_diff_db of Peak or dom = 0)
        fswell = (dfp+dfn)/4;
        Eswell = (E1+E2+E3+E4) / (S1P + S1N);
        Rswell = (S1+S2+S3+S4) / (S1P + S1N);
    end
% end

if isnan(dfn) && ~isnan(dfp)
        fswell = dfp/2;
        Eswell = (E3 + E4) / S1P;
        Rswell = (S3 + S4) / S1P;
end

if isnan(dfp) && ~isnan(dfn)
        fswell = dfn/2;
        Eswell = (E1 + E2) / S1N;
        Rswell = (S1 + S2) / S1N;
end

end % end of main function

%% Internal function: swell_peak.m
%  It is used to find the location of the swell peak
function [fp,Ep,Sp,i]=swell_peak(freq,PXY,f_low,f_high)
%
%% [fp,Ep,Sp,i]=swell_peak(freq,PXY,f_low,f_high)
%
% Function to find the location of the swell peak (fp) using a 4th order
% SNR weighting. It looks for swell peaks in PXY within the range f_low - f_high. 
% The largest peak that is a a weighted peak is identified. The integral of
% the swell peak over 5 points (2 points either side of the max) and the 
% energy at the swell peak  frequency (Ep) is calculated.
%
%% Input
% freq      - Doppler frequency in Hz of radar spectra
% PXY       - Doppler spectra in linear units
% f_low     - low freq. for swell region (f_low < swell <= f_high)
% f_high    - high freq. for swell region
%
%% Output
% fp        - Swell peak frequency (in Hz) SNR^4 weighting with two points on each side of swell peak
% Ep        - Max Doppler enegy at swell frequency peak
% Sp        - Integrated Doppler energy over 5 points centered at the swell peak
% i         - Indices of the integration for E_wang
%
%% Copyright 2019 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
% This file is part of RadarWIC.
%
% RadarWIC is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
np = 2; % Use 2 points on each side for centroid frequency and integral

i = find(freq >= f_low  &  freq <= f_high); % find indices of swell region
if isempty(i)
    fp = nan;
    Ep = nan;
    Sp = nan;
    return
end
f = freq(i(1):i(end) + np);     % Actual freqs
S = PXY((i(1):i(end) + np));    % Power in swell region
%-------------------------------------------------------------------------
if length (S)<3
    locs = [];
else
    [pks,locs] = findpeaks(S); % make sure it's a local peak
end
if isempty(locs)
    fp = nan;
    Ep = nan;
    Sp = nan;
    return
end
%-------------------------------------------------------------------------
[~,loci] = max(pks);          % biggest local peak
j = locs(loci);
%
jmin = max(1,j-np);
jmax = min(length(S),j+np);
j = jmin:jmax;
f = f(j);
S = S(j);
f = f(:);
S = S(:);
%
n = 4;                         % 4th order weighting
fp = sum(f.*S.^n)/sum(S.^n);   % ^n weighted frequency (SNR weighted) around peak
Sp = trapz(f,S);               % integral
Ep = interp1(f,S,fp,'linear'); % Energy at swell peak frequency from ^n weighting (4th order)
end