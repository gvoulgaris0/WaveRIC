%% specSwellRWIC.m
%  Function to estimate swell spectrum (Gaussian shape) and wave height
%%
function [Sfs,Hss] = specSwellRWIC(fw,fs,Eswell,as,sigma)
%% [Sfs,Hss] = specSwellRWIC(fw,fs,Eswell,as,sigma)
%
% Function to create a spectrum for the swell wave (Sf) and the corresponding swell
% significant waveheight (Hs). It used the radar non-weighted swell peaks found
% in the 2nd order sidebands between the Bragg peak and <fc. 
% It uses Gaussian-shape curve to represent the swell spectrum with a width
% of sigma.
%
%% Input
%  fw     - wave frequency range excluding near first order
%  fs     - swell peak frequency (Hz)
%  Eswell - Normalized by 1st order peak Doppler energy (at swell range)(Hz^-1) 
%  fradar - HF radar operating frequency in MHz
%  as     - swell calibration coefficient (entered in ConfigRWIC.m)
%  sigma  - [optional, default=0.08 (as in JONSWAP)] swell frequency (Gaussian) width (In Alattabi et al. 2019 =0.011)
%             
%% Output
%  Sfs    - Swell frequency wave spectrum (m^2/Hz)
%  Hss    - Significant waveheight of swell energy (m)
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
%% Main Program
% constants
global fradar
lradar  = 299.8/fradar;           % Bragg wavelength
k0      = 2*pi/lradar;

% swell spectrum of Gaussian form
if nargin<5 || sigma<0 || sigma >0.20
    sigma=0.08;     % Default value
end
hrms2 = (2*Eswell/k0^2)*as; % Hrms^2 
Hss   = sqrt(2*hrms2);      % Significant wave height, Hsig
Sfs   = ((Hss^2/16)/sqrt(2*pi*sigma^2))* exp( -(fw-fs).^2 ./ (2*sigma^2) );
end