%% specWindRWIC.m
%  Wind Wave Spectrum estimation from 2nd order sideband
%%
function [Sf,thw] = specWindRWIC(Rw,Dw,aw)
%% [Sf,thw] = specWindRWIC(Rw,Dw,aw)
%
% This function calculates the frequency wave spectrum (Sf) from radar 
% weighted and normalised 2nd order sideband (Rw) at a radar operating 
% frequency (fradar) with a calibration parameter (aw).
%
% It also calculates the wave direction (thw, two solutions) as a function
% of wave frequency (fw).
%
%% Input
%  Rw    - Normalised and wheighted 2nd order
%  Dw    - Ratio of normalized and weighted 2nd order sideband around a peak [(Rw_right_of_peak)/(Rw_left_of_peak)] 
%  aw    - Calibration coefficient (ex. 0.25)
%
%% Ouput
%  Sf    - Wave energy density spectrum (m^2/Hz)
%  thw   - Wave direction per frequency (thw(f), in degs)
%          direction is defined mathematically (i.e., toward) and it is measured
%          counterclockwise from radar beam direction. Two values are given
%          only one is correct (abiquity issue).
%
%% Global variables
%  fradar
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
%
global fradar
% constants
lradar  = 299.8/fradar;         % Bragg wavelength
k0      = 2*pi/lradar;          % Radar wavenumbers

% Inversion
Sf   = (Rw*2/k0^2).*aw;          % wind inversion

% S(f(1:j-1) = (Sf(j) * exp( -(f(1:j-1)-f(j)).^2 ./ (2*0.07^2) ));

% direction (s = 2) - Allatabi et al. submitted 2018
% (use D from dopWind.d instead of Dw to follow Gurgel et al. 2006)
th1 = 2*atand(+Dw.^0.5);
th2 = 2*atand(-Dw.^0.5);  
thw = [th1 th2];

end