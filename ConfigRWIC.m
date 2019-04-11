%% ConfigRWIC.m
% Configuration file that contains all adjustable parameters for swell and 
% the Radar Wave Inversion Code (RWIC)
%%
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
%
%% Global variables
%
global fradar g

%% System constants
g       = 9.81;                     % Gravity acceleration (m/s2)
lbragg  = 299.8/2/fradar;           % Bragg wavelength (m)
fbragg  = sqrt(g*2*pi/lbragg)/2/pi; % Bragg frequency (Hz)
df      = freq(2)-freq(1);          % Frequency bin resolution of Doppler spectrum
k0      = 2*pi/(2*lbragg);          % Radar wavenumber (rads/m)

%% Parameters defining details of analysis to be used
%
dom = 1;            % use only the side with the largest Bragg peak (for wind and Allatabi swell)
                    % when the difference between the two peaks is <3dB then use both sides.
peak_diff_db= 3;    % for use with dom = 1, the max peak difference to use both peaks
gaus_fit    = 1;    % fit gaussian for Bragg integral halfwidth
maxv        = 2;    % Max velocity (in m/s) defining the search region for Bragg peaks
np          = 5;    % number of points on each side of Bragg peak used for Bragg peak estimation
maxdf = maxv/lbragg;% Maximum Doppler shift expected (used to search for Bragg peaks, given maxv)

%% Parameters defining where to look for swell and second order spectra
%
Highf   = 0.5;      % Maximum wave freq (Hz); defines the second order upper limit
Lowf    = 0.025;    % Minimum wave freq (Hz); it defines the limit between 1st and 2nd order Doppler spectra
minf    = 0.02;     % Min halfwidth of Bragg Peak
minfs   = 0.05;     % Lowest swell peak frequency allowed (Hz)

%% Account for different ranges of wave frequencies obtained from the inner and outer side bands (for some HF radar operating frequencies the inner sideband of the Doppler spectrum (range 0 to Bragg freq) is too narrow, limiting the range of wave frequencies to a smaller range than that derived from the outer sideband).  
%
flim = 0.05;        % Lower Doppler frequency allowed to be used for estimating wave frequency (inner sideband limit) 
