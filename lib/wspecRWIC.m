%% wspecRWIC.m
%  Function to combine the inverted swell and wind wave spectra to a single
%  wave spectrum. S(f) = Sw(f)+Ss(f)
%%
function [Sfw,Sfs,Sf,th] = wspecRWIC(f,Rw,Sf_wind,Sf_swell,fc,thw,ths,jswaproll)
%% [Sfw,Sfs,Sf,th] = wspecRWIC(f,Rw,Sf_wind,Sf_swell,fc,thw,ths,jswaproll)
%
% Function to combine the swell and wind wave spectra to a single wave spectrum.
% It uses sideband ratio (Rw(f<fc)/Rw(f>fc) to decide if both spectra need to be
% merged into one. Otherwise the wind spectrum is returned.
%
% If Sf_swell and Sf_wind are combined, the left limit of the wind spectrum
% (Sf_wind) is assumed to be at the frequency bin where the Gaussian swell
%  spectrum (Sf_swell) decays to energies below the wind spectrum (Sf_wind.
% A JONSWAP roll-off is assumed for Sf_wind to the right of this point.
% The swell spectrum (Sf_swell) is used for all frequencies below this condition.
%
% The wave direction (th) is calculated in the same way from wind
% wave direction (thw) if swell wave direction (ths) is given. Otherwise
% thw is returned.
%
%% Input
%  f         - wave frequencies (Hz)
%  Rw        - 2nd order sideband ratio weighted by Barrick's weighting function
%  Sf_wind   - wind wave spectrum from radar inversion(m^2/Hz)
%  Sf_swell  - swell wave spectrum from swell radar inversion (m^2/Hz)
%  fc        - cutoff frequency, if the ratio of R(f<=fc) / R(f>fc) > 1,
%              then Sf_wind and Sf_swell are combined, otherwise Sf_wind
%              is returned
%  thw       - wind wave propagation direction as function of f
%  ths       - swell propagation direction [optional]
%  jswaproll - =1 apply JONSWAP roll off below last Rw value
%
%% Ouput
%  Sfw       - wind spectrum after accounting for the presence of swell
%              (JONSWAP roll-off applied to low frequencies)
%  Sfs       - swell spectrum after accounting for the presence of wind
%  Sf        - S(f) Wave spectral energy density(m^2/Hz)
%  th        - only calculated if input includes swell propagation direction (ths)
%              otherwise returns wind wave direction (thw)
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
j = f > fc;  % select wind wave frequencies
Rwind = nansum(Rw(j));
j = f <= fc; % select swell wave frequencies
Rswell= nansum(Rw(j));
Ratio = Rswell/Rwind;
disp(['Ratio = ' num2str(Ratio)])
% choose right method
if Ratio > 1 % Swell dominated conditions for deep waters (in the paper = 1.0)
    j = find(Sf_swell > Sf_wind,2,'last');
    if isempty(j)
        Sf = Sf_wind;
    else
        if j(2) == length(Sf_swell)
            j = j(1);
        else
            j = j(2);
        end
        if jswaproll == 1     % Apply the JONSWAP Roll-off
            Sf_wind(1:j) = Sf_wind(j+1)*exp(-((f(1:j)-f(j+1))/f(j+1)).^2 /(2*0.07^2));
        else
            Sf_wind(1:j) = 0;
        end
        Sf_swell(j+1:end) = 0;
        
        Sf  = Sf_swell + Sf_wind;  % Combine both spectra (Hybrid)
    end
    % Wave direction
    th = thw;
    if nargin > 6 && ~isempty(ths) % included wind and swell direction (thw and ths)
        th      = thw;
        th(1:j) = ths;             % swell direction when swell is above wind wave spec
    end
else
    if jswaproll == 1              % Apply the JONSWAP Roll-off
        j = find(Sf_wind > 0,1) - 1;
        if j > 0
            Sf_wind(1:j)      = Sf_wind(j+1)*exp(-((f(1:j)-f(j+1))/f(j+1)).^2 /(2*0.07^2));
        end
    end
    
    Sf = Sf_wind;        % Only wind wave spectrum is used
    Sf_swell=Sf_swell*0; % Null out swell spectrum
    th = thw;            % direction
end
%
Sfw = Sf_wind;
Sfs = Sf_swell;
end