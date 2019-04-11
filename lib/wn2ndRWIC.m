%% wn2ndRWIC.m
%  Estimate the weighted, normalised 2nd-order Doppler spectra to be
%  used for the inversion.
%
function [R,Rw,fw,D,Dw,debug] = wn2ndRWIC(freq,PXY,swplot)
%% [R,Rw,fw,D,Dw,debug] = wn2ndRWIC(freq,PXY,[swplot])
%
% This function calculates the 2nd order Doppler part to be used for the wave 
% inversion. This is normalized by the 1st order energy and Rw is weighted using 
% Barrick's weighting function, while R is non-weighted.  It also estimates the 
% corresponding wave frequencies (fw) for each Rw and R estimate.
%
%% Input
%  freq:        Array of Doppler frequencies for the Doppler spectrum (in Hz)
%  PXY(1:freq): Array of Spectral Energy (in dB), do not send arrays of NaN
%  swplot:      >0 if you want a plot [optional, default no plot]
%
%% Output
%  fw:        Ocean wave frequencies (in Hz)
%  R:        (no units) normalized (no weighted) 2nd order sideband
%  Rw:       (no units) weighted (by Barrick's weighting function)and normalized 2nd order sideband
%  D:        (no units) Ratio of normalized 2nd order sidebands around a peak [(R_right_of_peak)/(R_left_of_peak)]
%  Dw:       (no units) Ratio of normalized & weighted 2nd order sideband around a peak [(Rw_right_of_peak)/(Rw_left_of_peak)]
%  debug:    Structure variable to be used for debugging purposes
%
%% Debugging  
%  Extra data to be used for debugging purposes for each sideband.
%  debug.fw1-n  the ocean wave frequency from the Doppler spectra for sideband n
%  debug.E1-n   Doppler energy for sideband n
%  debug.R1-n   normalized (by 1st order) 2nd order sideband for sideband n
%  debug.Rw1-n  normalized and weighted 2nd order sideband for sideband n
%                where n=1,2,3,or 4 
%                with 1 and 2 indicating negative frequencies
%                     3 and 4 positive frequencies
%                     1 and 3 left of the adjacent Bragg peak
%                     2 and 4 right of the adjacent Bragg peak
%  debug.SNR1   signal to noise ratio for 1st order
%  debug.SNR2   signal to noise ratio for 2nd order
%  debug.sigma1 width of Bragg peak
%  debug.Noise  Noise level
%  debug.S11    ratio of std of Bragg peak region (to get wind direction/local wind wave direction)
%  debug.braggpeaksSNR Bragg peak SNR for positive and negative side peaks
%
%% Uses
%  ConditionDopRWIC.m, PXYsideband.m
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
%% Main function
% call dop_common that pre-treates the Doppler spectrum (i.e., Noise identification,
% Bragg peak identification etc. See inside dop_common function for more information.
ConditionDopRWIC;    % Loading parameters
double_outer = 1;    % flag to indicate uneven wave freq. ranges from inner and outer sidebands and account for it. 

%
if nargin<3
    swplot=-10;
end
%
% continuum R calculations
% fw - wave frequency (in Hz)
% R  - 2nd order (no units)
% Rw - 2nd order weighted by Barrick's weighting function (no units)
% Indices 1 to 4 are used to denote sidebands counting from lowest f to highest:
%    1-neg. freg. left of negative peak, 2-neg. side right of negative peak
%    3-pos. freq. left of positive peak, 4-pos. side right of positive peak

[fw1,E1,Ew1,fi1] = PXYsideband(freq,PXY,fn-Highf,fn-Lowfn,fn,1);
[fw2,E2,Ew2,fi2] = PXYsideband(freq,PXY,fn+Lowfn,fn+Highf,fn,2);
[fw3,E3,Ew3,fi3] = PXYsideband(freq,PXY,fp-Highf,fp-Lowfp,fp,3);
[fw4,E4,Ew4,fi4] = PXYsideband(freq,PXY,fp+Lowfp,fp+Highf,fp,4);

debug.E1  = E1;      debug.E2  = E2;      debug.E3  = E3;      debug.E4  = E4;
debug.R1  = E1/S1N;  debug.R2  = E2/S1N;  debug.R3  = E3/S1P;  debug.R4  = E4/S1P;
debug.Rw1 = Ew1/S1N; debug.Rw2 = Ew2/S1N; debug.Rw3 = Ew3/S1P; debug.Rw4 = Ew4/S1P;
debug.fw1 = fw1;     debug.fw2 = fw2;     debug.fw3 = fw3;     debug.fw4 = fw4;
debug.Noise = Noise; debug.S11 = [S1n S1p];
debug.braggpeaksSNR = [S1Npeak S1Ppeak]./Noise;

if (dom == 1  && S1P < S1N) || (dom ~=1 && S1P < S1N/10^(peak_diff_db/10)) % Negative Bragg peak is dominant
    % do not cross flim (default 0 Hz) for inner sideband
    E2(fi2 > -flim) = 0;    % negative peak inner sideband limit
    Ew2(fi2 > -flim) = 0;   % inner weighted
         
    E2  = interp1(fw2,E2 ,fw1,'linear');        % extrap frequencies to match each side of Bragg peak (inner to outer)
    Ew2 = interp1(fw2,Ew2,fw1,'linear');
    
    % do not cross flim (default 0 Hz) for inner sideband
    iw2 = find(fi2 > -flim,1) - 1;
    if iw2 > 1
        fw2lim = fw2(iw2);        % last wave frequency below flim in inner sideband
        if ~isempty(fw2lim)
             if double_outer == 1 % optional doubling of outer sideband above this limit
                E1(fw1 > fw2lim) = 2*E1(fw1 > fw2lim);   % outer
                Ew1(fw1 > fw2lim) = 2*Ew1(fw1 > fw2lim); % outer weighted
            end
        end
    end
    
    R  = (E1+E2)   / S1N; % unweighted second order ratio
    Rw = (Ew1+Ew2) / S1N; % ratio with Barrick wind-wave weighting
    fw = fw1;
    D  = E1./E2;     % unweighted 2nd order sideband direction ratio (positive sideband / negative sideband)
    Dw = Ew1./Ew2;   % weighted 2nd order sideband direction ratio
    
    debug.SNR2   = max(Ew1+Ew2)/2;
    debug.SNR1   = max(max(S1Npeak));
    debug.sigma1 = sigman;
    
elseif (dom == 1  &&  S1N < S1P) || (dom~=1 && S1N < S1P/10^(peak_diff_db/10)) % Positive Bragg peak is dominant
    % do not cross flim (default 0 Hz) for inner sideband - set values to 0
    E3(fi3 < flim) = 0;    % negative peak inner sideband limit
    Ew3(fi3 < flim) = 0;   % inner weighted
    
    E3  = interp1(fw3,E3 ,fw4,'linear'); % extrap frequencies to match each side of Bragg peak (inner to outer)
    Ew3 = interp1(fw3,Ew3,fw4,'linear');
    
    % last wave frequency below flim in inner sideband
    iw3 = min(find(fi3 < flim,1,'last') + 1,length(fi3));
    if iw3 > 1
        fw3lim = fw3(iw3);
        if ~isempty(fw3lim)
            if double_outer == 1 % optional doubling of outer sideband above this limit
                E4(fw4 > fw3lim) = 2*E4(fw4 > fw3lim);  % outer
                Ew4(fw4 > fw3lim)= 2*Ew4(fw4 > fw3lim); % outer weighted
            end
        end
    end
    
    R  = (E3+E4)   / S1P; % unweighted second order ratio
    Rw = (Ew3+Ew4) / S1P; % ratio with Barrick wind-wave weighting
    fw = fw4;
    D  = E3./E4;         % unweighted 2nd order sideband direction ratio (positive sideband / negative sideband)
    Dw = Ew3./Ew4;       % weighted 2nd order sideband direction ratio
    
    debug.SNR2   = max(Ew3+Ew4)/2;
    debug.SNR1   = max(max(S1Ppeak));
    debug.sigma1 = sigmap;
    
else % within peak_diff_db of Peak or dom = 0
    E1  = interp1(fw1,E1 ,fw4,'linear'); % extrap all frequencies to match fw4 (pos outer)
    E2  = interp1(fw2,E2 ,fw4,'linear');
    E3  = interp1(fw3,E3 ,fw4,'linear');
    Ew1 = interp1(fw1,Ew1,fw4,'linear');
    Ew2 = interp1(fw2,Ew2,fw4,'linear');
    Ew3 = interp1(fw3,Ew3,fw4,'linear');
    
    R  = (E1+E2+E3+E4)/(S1P+S1N);      % unweighted normalised 2nd second order
    Rw = (Ew1+Ew2+Ew3+Ew4)/(S1P+S1N);  % Barrick wind-wave weighted and normalised 2nd order
    fw = fw4;    
    D  = (E1+E3)./(E2+E4);             % unweighted normalised 2nd second order
    Dw = (Ew1+Ew3)./(Ew2+Ew4);         % Barrick wind-wave weighted and normalised 2nd order
    
    debug.SNR2   = max(Ew1+Ew2+Ew4)/4;
    debug.SNR1   = max(S1Npeak+S1Ppeak)/2;
    debug.sigma1 = nanmean([sigmap;sigman]);
end
%
if fw(2) < fw(1)
    fw = flip(fw);
    R  = flip(R);
    Rw = flip(Rw);
end
%
% extend to 0 Hz
dfw = fw(2) - fw(1);
fw  = fw(end):-dfw:0;
fw  = fliplr(fw)';
k   = length(fw) - length(Rw); 
Rw0 = nan(k,1);
Rw  = [Rw0 ; Rw];
R   = [Rw0 ; R];
Dnan = nan(k,1);
D    = [Dnan ; D];
Dw   = [Dnan ; Dw];
%
%plot
if swplot>0
    plot_wind;  
end % end of plot
end % end of main function
