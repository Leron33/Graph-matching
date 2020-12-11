% Includes a new curve into the comparison plot of all methods that
% participated in the SHREC'16 contest on topological noise. 
% Needs results from shrec_grampa.m (just uncomment line 20 at the first run)
% written by Zorah Lähner (laehner@in.tum.de)
% Revised by Jiaming Xu Feb. 8 2020
%% PREPARE
clear all;
path_kids = '';          % path to the complete TOPKIDS data set
track = 'low resolution/';  % low or high resolution
%% CALCULATE CURVES
thresholds = 0:0.01:0.25;
% calculate kims curves
curves = zeros(90,length(thresholds));
k = 0; 
for i=16:25
    for j=16:25
        if i ~= j
            k = k + 1  
            tic;
          curves(k,:)=shrec_grampa(i,j,path_kids,track);  % run GRAMPA
%              S=load(strcat(path_kids,track, 'kid', num2str(i), '_kid', num2str(j), '.mat'),'curve');
            curves(k,:)=S.curve;                                          % read data
            toc;
            fprintf('Correct percentage at iter %i is %4.2d\n', k,curves(k,1));
        end
    end
end
%% FIGURE
h = openfig('./low_resolution.fig');
hold on,
plot(thresholds', mean(curves, 1)'), ylim([0 100]);
legend({'EM', 'GE', 'RF', 'GRAMPA'},'FontSize', 14);
line_width=1.5;
hline = findobj(gcf, 'type', 'line');
set(hline,'LineWidth',line_width);
% savefilename='grampa_low_resolution';
% saveas(gcf, savefilename, 'fig');