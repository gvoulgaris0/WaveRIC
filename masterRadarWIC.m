%% masterRadarWIC.m
%
% This is an example master script that shows how to utilize the RadarWIC.m 
% model.
%
% It uses two examples of spectra from a VHF system, the files are located 
% in subdirectory data/
%
% More adjustable parameters are located in script configRWIC.m
% see comments inside the script for more details.
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
%% Doppler spectrum data files available
% spec = 'data/VHF_beam1.mat'; % filename of Dopppler spectrum
% spec = 'data/VHF_beam2.mat'; % filename of Dopppler spectrum
% spec = 'data/VHF_beam3.mat'; % filename of Dopppler spectrum
%
%% HF radar and inversion specific parameters
fr     = 48;     % HF/VHF radar operating frequency in Mhz
swplot = 1;      % =1 if plots are required for debugging or other reasons
                 % ploting calls functions: (1) swell_plot.m and (2) wind_plot.m
fc     = 0.12;   % frequency (in Hz) separating swell from wind waves region used for estimating Rw and Rs
                 % if the ratio (Rs(f<fc) / Rw(f>fc) > 1
                 % inverts for swell otherwise assumes no swell is present.
jswaproll = 0;   % =1 apply JONSWAP roll off below last Rw value
%% Inversion Model Calibration coefficients (see Alattabi et al., 2019)
aw     = 0.25;   % wind cal. coefficient (empirical, but should be constant) - used for wind inversion
as     = 0.05;   % swell cal. coefficient (empirical fit) - see Alattabi et al (2019) for swell module
sigma  = 0.011;  % swell spectral width coefficient (empirical fit) - for creating a Gaussian swell spectrum

%% Inversion Model Output:
%   f         - Wave frequencies (f)
%   Sfx       - Wave energy spectral density (S(f))
%   thw       - Wave directional spectrum (D(f))
%   Hs        - Significant wave height (Hsig)
%   fp        - Peak wave frequency (fp)
%   fm        - Mean wave frequency (fm)
%   thp       - Wave peak direction
%   thm       - Wave mean direction
%   params_x  = [Hs, fp, fm, thp, thm]
%               where x (= w,s or h) denotes the part of spectrum so that:
%               w  for wind waves:       Sfw, thw, params_w
%               s  for swell waves:      Sfs, n/a, params_s
%               h  for combined (total): Sfh, thw, params_h
%
%% Load HF radar spectrum
% load(spec);         % load Doppler spectrum file from radar (f,PXY)

%% Calling main model RadarWIC (hybrid inversion, see Alattabi et al., 2019)
[f,Sfw,thw,Sfs,Sfh] = RadarWIC(freq,PXY,fr,aw,as,sigma,fc,jswaproll,swplot);
% choose correct wave direction solution thw1 or thw2 (need additional data for this)
thw = thw(:,1); 
% thw = thw(:,2) 

% calculation of wave bulk parameters from the inverted spectra:
params_w = waveparams(f,Sfw,thw);    % wind wave partitioned spec
params_s = waveparams(f,Sfs);        % swell partitioned spec
params_h = waveparams(f,Sfh,thw);    % total (wind+swell) spec
%--------------------------------------------------------------------------
%% Display output
%
Comment1=['Wave Inversion model RadarWIC as described in Alattabi et al (2019)'];
Comment2=['Calibration factors: aw=',num2str(round(aw,2)),'  as=',num2str(round(as,2))];
Comment3=['Swell broadening sigma =',num2str(round(sigma,3)),'Swell/Wind fc(Hz)=',num2str(round(fc,2))];
disp(Comment1)
disp(Comment2)
disp(Comment3)
X0 = sprintf('%s','          Hs   fp  fm  theta_p theta_m');
X1 = sprintf('%s %2.2f  %2.2f %2.2f %2.1f  %2.1f','Wind  : ',params_w);
X2 = sprintf('%s %2.2f  %2.2f %2.2f %2.1f  %2.1f','Swell : ',params_s);
X3 = sprintf('%s %2.2f  %2.2f %2.2f %2.1f  %2.1f','Hybrid: ',params_h);
disp(X0)
disp(X1)
disp(X2)
disp(X3)
