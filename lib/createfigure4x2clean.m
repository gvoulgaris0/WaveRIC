function createfigure4x2clean(X1a,Y1a,X2a,Y2a,X1b,Y1b,X2b,Y2b,X1c,Y1c,X2c,Y2c,X1d,Y1d,X2d,Y2d,X1e,Y1e,X2e,Y2e,X1f,Y1f,X2f,Y2f,X1g,Y1g,X2g,Y2g,X1h,Y1h,X2h,Y2h)

%  Auto-generated by MATLAB on 08-Feb-2019 17:37:35
%  plot function to recreate the figure in the paper

% Create figure
figure('InvertHardcopy','off','Color',[1 1 1],'OuterPosition',[593.8 -9.4 542.4 864]);
%%==========================================================================
subplot_spec4x2(X1a,Y1a,X2a,Y2a,1);  % Event A
subplot_spec4x2(X1b,Y1b,X2b,Y2b,2);  % Event B
subplot_spec4x2(X1c,Y1c,X2c,Y2c,3);
subplot_spec4x2(X1d,Y1d,X2d,Y2d,4);
subplot_spec4x2(X1e,Y1e,X2e,Y2e,5);
subplot_spec4x2(X1f,Y1f,X2f,Y2f,6);
subplot_spec4x2(X1g,Y1g,X2g,Y2g,7);
subplot_spec4x2(X1h,Y1h,X2h,Y2h,8);  % Event H
end

function subplot_spec4x2(X1,Y1,X2,Y2,nplot)
%
% subplot_spec4x2(X1,Y1,X2,Y2,nplot)
%
% Function that plots Y1 vs X1 and Y2 vs X2 in a single plot. The plot is
% part of a 4 rows 2 columns panels of a single figure.
%
% Use value nplot to assign event symbol (A to H)
letter = char(nplot + 64);
% decide on subplot position
if nplot>4
    ig=1;
    np=nplot-4;
else
    ig=0;
end
y1 = 0.765; dy = 0.235;
yy = y1-(np-1)*dy;
x1 = 0.09;  dx = 0.45;
xx = x1+ig*dx;
% xlabel
xlab = 'Frequency (Hz)';
ylab = 'S(f) (m^{2}/Hz)';
%
% Create axes
axes1 = axes('Position',[xx yy 0.44 0.215]);
hold(axes1,'on');
% Create loglog plot
loglog(X1,Y1,'MarkerSize',8,'LineWidth',1,'Color',[0 0 1]);
loglog(X2,Y2,'MarkerSize',8,'LineWidth',1,'Color',[1 0 0]);
a1 = 1.1*(.25^4);
a2 = 1.1*(.25^5);
loglog([0.15 0.5],a1*[0.15 0.5].^(-4)) % f^-4 line
loglog([0.15 0.5],a1*[0.15 0.5].^(-5)) % f^-5 line
% Create text
text('LineWidth',1,'FontName','arial','String',letter,'Position',[0.055 20 0]);
xlim(axes1,[0.052 0.5]);
ylim(axes1,[0.003 50]);
box(axes1,'on');
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontName','arial','GridAlpha',1,'GridColor',[0.8 0.8 0.8],...
    'GridLineStyle',':','LineWidth',1,'TickDir','out','TickLength',[0.01 0.01],...
    'XMinorGrid','on','XMinorTick','on','XScale','log','XTickLabel',{},...
    'YMinorTick','on','YScale','log');
% Create ylabel on left side plots only
if nplot<=4
    ylabel(ylab,'LineWidth',1,'FontName','arial');
end
% Create xlabel on bottom plots only
if nplot==4 || nplot==8
    xlabel(xlab,'LineWidth',1,'FontName','arial');
end
end