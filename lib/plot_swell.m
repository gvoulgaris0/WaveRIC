%% plot_swell
% Script to plot the analysis for Swell
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
%
%% Doppler swell analysis plot
%
% original spec, Noise level, and Spec with Noise removed
h3 = plot(freq,10*log10(PXY),'k','linewidth',2);            % noise removed
hold on
h4 = plot(freq(in),10*log10(PXY(in)),'m','linewidth',2);    % Bragg peak integration region negative
plot(freq(ip),10*log10(PXY(ip)),'m','linewidth',2);         % Bragg peak integration region positive
% swell 2nd order sidebands
if ~isnan(si1)
h5=plot(freq(si1),10*log10(PXY(si1)),'r','linewidth',2);
end
if ~isnan(si2)
h5=plot(freq(si2),10*log10(PXY(si2)),'r','linewidth',2);
end
if ~isnan(si3)
h5=plot(freq(si3),10*log10(PXY(si3)),'r','linewidth',2);
end
if ~isnan(si4)
h5=plot(freq(si4),10*log10(PXY(si4)),'r','linewidth',2);
end
% swell peaks for each sideband
plot(f1,10*log10(E1),'bs','MarkerFaceColor',[0.8,0.8,0.8])
plot(f2,10*log10(E2),'bs','MarkerFaceColor',[0.8,0.8,0.8])
plot(f3,10*log10(E3),'bs','MarkerFaceColor',[0.8,0.8,0.8])
plot(f4,10*log10(E4),'bs','MarkerFaceColor',[0.8,0.8,0.8])
ylim([10*log10(Noise*0.2) max(10*log10(PXY_or*1.2))])
nr = 4; % swell freqs
text(f1-55*df,5+10*log10(E1*1.25),num2str(round(10^nr*(f1-fn))/10^nr))
text(f2,5+10*log10(E2*1.25),num2str(round(10^nr*(f2-fn))/10^nr))
text(f3-55*df,5+10*log10(E3*1.25),num2str(round(10^nr*(f3-fp))/10^nr))
text(f4,5+10*log10(E4*1.25),num2str(round(10^nr*(f4-fp))/10^nr))
title('RadarWIC - Swell Analysis','FontSize',10,'FontWeight','normal')
xlabel('f_D (Hz)');
ylabel('(dB)')

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
legend( [h3 h4 h5],'\sigma(f_D)-n','\int \sigma_1(f_D)df_D','\sigma_2(f_D)-swell')