%% plot_wind.m
% Script plotting the decomposition of the Radar Doppler spectrum
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
%% Doppler wind analysis plot
% original spec, Noise level, and Spec with Noise removed
plot(freq,10*log10(PXY_or),'-.k','linewidth',.5) % Original spec
hold on
plot([freq(1) freq(end)],[10*log10(Noise) 10*log10(Noise)],'r','linewidth',1) % Noise level
plot(freq,10*log10(PXY),'k','linewidth',2) % noise removed

% Bragg peak integration regions
plot(freq(in),10*log10(PXY(in)),'m','linewidth',2)

% 2nd order continuous sidebands
plot(fi1,10*log10(debug.E1),'b','linewidth',2)

% Bragg peak integration regions
plot(freq(ip),10*log10(PXY(ip)),'m','linewidth',2)

% 2nd order continuous sidebands
plot(fi2,10*log10(debug.E2),'b','linewidth',2)
plot(fi3,10*log10(debug.E3),'b','linewidth',2)
plot(fi4,10*log10(debug.E4),'b','linewidth',2)

ylim([10*log10(Noise*0.2) max(10*log10(PXY_or*1.2))])

ylabel('(dB)');
xlabel('f_D (Hz)');
title('RadarWIC - Wind Wave Analysis','FontSize',10,'FontWeight','normal')
grid on
set(gca,'linewidth',1);
ax =gca;
ax.GridAlpha = 1;
ax.GridColor =  [0.8 0.8 0.8];
ax.GridLineStyle = ':';
ax.LineWidth = 1;
ax.TickLength  = [0.01 0.005];
% ax.XMinorTick = 'on';
% ax.YMinorTick = 'on';
ax.FontSize=8;
set(gca,'fontname','arial','FontSize',10,'FontWeight','normal');
set(gca,'linewidth',1);
box off
legend('\sigma(f_D)','n=Noise','\sigma(f_D)-n','\int \sigma_1(f_D)df_D','\sigma_2(f_D)')
