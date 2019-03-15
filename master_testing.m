%% Example script on how to use the RadarWIC code to invert the HF Radar signal
%  It uses data from station N4 and O2 as described in Alattabi et al.,
%  2019 to reproduce Figures x and y in the paper.
%
%% Use data from site N4 (see Alattabui et al., 2019)
clear
basedir = 'data/N4/';
fdir    = dir(basedir);
for i = 3:length(fdir)
    clear f PXY
    fn = fdir(i).name;
    if strcmp(fn(1:3),'dop')
        % load data file
        disp(fn)
        load([basedir fn])
        freq = f;
        clear f   
        % run RadarWIC
        masterRadarWIC       
        % save results of inversion
        save([basedir fn(5) '_inv.mat'],'f','thw','Sfh');
        eval(['aX2' fn(5) ' = f;'])
        eval(['aY2' fn(5) ' = Sfh;'])       
        % load in situ spectra for plot / comparison
        insitu = load([basedir 'insitu_' fn(5) '.mat']);
        eval(['aX1' fn(5) ' = insitu.f;'])
        eval(['aY1' fn(5) ' = insitu.Sf;'])
    end
end
% plot N4
figure('InvertHardcopy','off','Color',[1 1 1],'OuterPosition',[593.8 -9.4 542.4 864]);
subplot_spec4x2(aX1A,aY1A,aX2A,aY2A,1); title('N4')
subplot_spec4x2(aX1B,aY1B,aX2B,aY2B,2);
subplot_spec4x2(aX1C,aY1C,aX2C,aY2C,3);
subplot_spec4x2(aX1D,aY1D,aX2D,aY2D,4);
subplot_spec4x2(aX1E,aY1E,aX2E,aY2E,5);
subplot_spec4x2(aX1F,aY1F,aX2F,aY2F,6);
subplot_spec4x2(aX1G,aY1G,aX2G,aY2G,7);
subplot_spec4x2(aX1H,aY1H,aX2H,aY2H,8);
legend('in-situ','inverted');

%% Use data from site O2 (see Alattabi et al., 2019)
basedir = 'data/O2/';
fdir = dir(basedir);
for i = 3:length(fdir)
    clear f PXY
    fn = fdir(i).name;
    if strcmp(fn(1:3),'dop')
        % load file
        disp(fn)
        load([basedir fn])
        freq = f;
        clear f   
        % run RadarWIC
        masterRadarWIC
        % save results of inversion
        save([basedir fn(5) '_inv.mat'],'f','thw','Sfh');
        eval(['X2' fn(5) ' = f;'])
        eval(['Y2' fn(5) ' = Sfh;'])
        % load in situ spectra for plot / comparison
        insitu = load([basedir 'insitu_' fn(5) '.mat']);
        eval(['X1' fn(5) ' = insitu.f;'])
        eval(['Y1' fn(5) ' = insitu.Sf;'])
    end
end
%% plot O2
figure('InvertHardcopy','off','Color',[1 1 1],'OuterPosition',[593.8 -9.4 542.4 864]);
subplot_spec4x2(X1A,Y1A,X2A,Y2A,1); title('O2')
subplot_spec4x2(X1B,Y1B,X2B,Y2B,2);
subplot_spec4x2(X1C,Y1C,X2C,Y2C,3);
subplot_spec4x2(X1D,Y1D,X2D,Y2D,4);
subplot_spec4x2(X1E,Y1E,X2E,Y2E,5);
subplot_spec4x2(X1F,Y1F,X2F,Y2F,6);
subplot_spec4x2(X1G,Y1G,X2G,Y2G,7);
subplot_spec4x2(X1H,Y1H,X2H,Y2H,8);
legend('in-situ','inverted');
%% plot N4 and O2
figure('InvertHardcopy','off','Color',[1 1 1],'OuterPosition',[593.8 -9.4 542.4 864]);
subplot_spec4x2ab(aX1A,aY1A,aX2A,aY2A,X1A,Y1A,X2A,Y2A,1);
subplot_spec4x2ab(aX1B,aY1B,aX2B,aY2B,X1B,Y1B,X2B,Y2B,2);
subplot_spec4x2ab(aX1C,aY1C,aX2C,aY2C,X1C,Y1C,X2C,Y2C,3);
subplot_spec4x2ab(aX1D,aY1D,aX2D,aY2D,X1D,Y1D,X2D,Y2D,4);
subplot_spec4x2ab(aX1E,aY1E,aX2E,aY2E,X1E,Y1E,X2E,Y2E,5);
subplot_spec4x2ab(aX1F,aY1F,aX2F,aY2F,X1F,Y1F,X2F,Y2F,6);
subplot_spec4x2ab(aX1G,aY1G,aX2G,aY2G,X1G,Y1G,X2G,Y2G,7);
subplot_spec4x2ab(aX1H,aY1H,aX2H,aY2H,X1H,Y1H,X2H,Y2H,8);
legend('N4 in-situ',' N4 inverted', 'O2 in-situ',' O2 inverted');