%%  RadarWIC.m
%  Main function for the Radar Wave Inversion Code (RadarWIC)
%
%  Alattabi, Z. D. Cahl, and G. Voulgaris, 2019. Swell and Wind Wave 
%  Inversion Using a Single Very High Frequency (VHF) Radar. Journal of
%  Oceanic and Atmopsheric Technology, xx: yyyy-yyyy
%
function [f,Sfw,thw,Sfs,Sfh] = RadarWIC(freq,PXY,fr,aw,as,sigma,fc,jswaproll,swplot)
%% [f,Sfw,thw,Sfs,Sfh] = RadarWIC(freq,PXY,fr,aw,as,sigma,fc,jswaproll,swplot)
%
% This function uses Doppler spectra from a VHF/HF radar, identifies its
% 2nd order continuum and inverts it to create an ocean wave spectrum.
%
% For details see:
%
% Alattabi, Z. D. Cahl, and G. Voulgaris, 2019. Swell and Wind Wave 
% Inversion Using a Single Very High Frequency (VHF) Radar. Journal of
% Oceanic and Atmopsheric Technology, xx: yyyy-yyyy
%
% The function:
%
% 1. Identifies the 2nd order sides of Doppler spectrum and creates the
%    weighed and normalized by the 1st order spectra (Rw)
% 2. Inverts Rw to wind wave spectrum (Sfw) using the appropiate calibration
%    coefficient (aw)
% 3. Estimates the swell part of the spectrum using Alatabi et al. 2019.
% 4. Inverts the swell part of Rw to a spectrum using a Gaussian function
%    with width sigma and using the swell calibration factor "as".
%
%    Inversion parameters are set in file:  ConfigRWIC.m
%
%% Inputs
%   freq       - frequency of the radar Doppler spectrum
%   PXY        - Doppler power spectrum PXY(freq)
%   fr         - HF radar operating frequency in Mhz
%   aw         - wind coefficient (empirical, but should be constant) - used for wind inversion
%   as         - swell coefficient for the Alattabi et al. (2018) model (empirical fit) - used for swell inversion
%   sigma      - Gaussian swell spectrum width (empirical fit) - used for swell inversion
%   fc         - cutoff frequency (in Hz) separating swell from wind waves region;
%                It limits swell peak freq. below this value; it is also used by the hybrid model ratio test (see Allatabi et al.,2018).
%                if Rw(f<fc) / Rw(f>fc) > 1, uses swell inversion - more information in hybrid.m
%   jswaproll  - if =1 [default] apply JONSWAP roll off below last Rw value
%   swplot     - plots for debugging, calls swell_plot.m, wind_plot.m, inv_plot.m
%   swplot_inv - for plotting each spectrum inversion
% 
%% Outputs
%   f          - Wave frequency for the spectral estimates (Hz)
%   Sfw1       - Wind wave energy spectral density (Sw(f), m2/Hz)
%   thw        - Wave directional spectrum (D(f), m2/deg)
%   Sfs        - Swell energy spectral density (Ss(f))
%   Sfh        - Total energy spectral density (S(f)=Sw(f)+Ss(f))
%
%% Uses
%   dopWind.m; findSwellRWIC.m; invWind.m; specSwellRWIC.m; wspecRWIC.m
%   ConfingRWIC.m
% 
%
%% Copyright 2019 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
% This program is free software: you can redistribute it and/or modify
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

%% Main Function
% program setup    
addpath('lib')       % add path with required subroutines
global fradar
fradar  = fr;

% subplot for Doppler spectra and sidebands
if swplot > 0       
    figure('Name','Radar Wave Inversion Code (RWIC)','Position',[100 50 600 700])
    subplot(311)
end

% Doppler analysis and wind wave inversion
[R,Rw,f,D,Dw]  = wn2ndRWIC(freq,PXY,swplot);  % Doppler spectrum to norm. 2nd order
[Sfw,thw]      = specWindRWIC(Rw,Dw,aw);      % wind wave inversion
Sfw(isnan(Sfw))= 0;

% subplot for swell peaks
if swplot > 0 
    subplot(312)
end

% Swell analysis and inversion
[fs,Es]        = findSwellRWIC(freq,PXY,fc,swplot);
[Sfs,Hss]      = specSwellRWIC(f,fs,Es,as,sigma);
Sfs(isnan(Sfs))= 0;
ths            = [];

% Combine hybrid inversion of wind and swell
[Sfw1,Sfs1,Sfh,thh] = wspecRWIC(f,Rw,Sfw,Sfs,fc,thw,ths,jswaproll);
% thh is identical to thw since ths is empty

% plot inverted wave spectrum
if swplot > 0 % 
    subplot(313)
    plot(f,Sfw,'-.','linewidth',0.5)
    hold on
    plot(f,Sfw1,'linewidth',1.5)
    plot(f,Sfs,'linewidth',1.5)
    plot(f,Sfh, 'k:', 'linewidth',1.5)
    xlabel('f(Hz)');
    ylabel('Sf(m^{2}/Hz)')
    legend('Sfwo(f)','Sw(f)','Ss(f)','Sw(f)+Ss(f)')
    title('RadarWIC - Inverted spectra components','FontSize',10,'FontWeight','normal')
    xlim([0.01 0.5])
    set(gca,'fontname','arial','FontSize',10,'FontWeight','normal');
    set(gca,'linewidth',1);
    grid on
    box off
end
Sfs = Sfs1;
end

