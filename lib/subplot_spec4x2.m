function subplot_spec4x2(X1,Y1,X2,Y2,nplot)
%
% Use value nplot to assign letter symbol (A to H)
letter = char(nplot + 64);
% decide on subplot position
if nplot>4
    ig=1;
    np=nplot-4;
else
    ig=0;
    np=nplot;
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
% Create loglog
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
box(axes1,'off');
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontName','arial','GridAlpha',1,'GridColor',[0.8 0.8 0.8],...
    'GridLineStyle',':','LineWidth',1,'TickDir','out','TickLength',[0.01 0.01],...
    'XMinorGrid','on','XMinorTick','on','XScale','log',...
    'YMinorTick','on','YScale','log');
% Create ylabel on left side plots only
if nplot<=4
    ylabel(ylab,'LineWidth',1,'FontName','arial');
else
    set(axes1,'YTickLabel',{});
end
% Create xlabel on bottom plots only
if nplot==4 || nplot==8
    xlabel(xlab,'LineWidth',1,'FontName','arial');
else
    set(axes1,'XTickLabel',{});
end
end
