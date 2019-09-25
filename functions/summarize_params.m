% make a pretty plot that summarizes the predictions of a model
% assumes that params is already loaded.
% 7/12/05 -- (PH) updated for new params setup
% 7/15/05 -- (PH) made into a function 
% 8/10/04 == (AR) stdev calculated correctly now & comments for why I do what I do
% 5/27/14 -- (EM) added region mean differences

% function summarize_params(params)
function [ params ] = summarize_params(params)

regions = [params.img.region.bg params.img.region.hi params.img.region.lo];
mean_out = mean(mean(params.out.img));

stdevs = params.out.regions.stdev(regions);
means = params.out.regions.mean(regions) - mean_out; % recenter on mean, plot only makes sense when mean = gray

% find the differences between the high and low regions
params.out.regions.diff = params.out.regions.mean(params.img.region.hi) ...
    - params.out.regions.mean(params.img.region.lo);

plot_std_dev = (stdevs .* sign(means)) + means; % adding means so that plot lines will be relative to mean and not 0 

%function createfigure(y1, y2)
%CREATEFIGURE(Y1,Y2)
%  Y1:  bar y
%  Y2:  stem y

y1 = means;
y2 = plot_std_dev;
%  Auto-generated by MATLAB on 06-Jul-2005 12:06:55
 
%% Create figure
figure1 = figure;
 
%% Create axes
axes1 = axes(...
  'XTick',[1:length(means)],...
  'XTickLabel',{sprintf('BG (%0.3f)', means(1)),sprintf('Hi (%0.3f)', means(2)), sprintf('Lo (%0.3f)', means(3))},...
  'Parent',figure1);
xlim(axes1,[0.5 length(means) + 0.5]);
hold(axes1,'all');
 
%% Create bar
bar1 = bar(y1);
 
%% Create stem
stem1 = stem(y2);

title(strrep([params.img.stim ' - ' params.norm.settings], '_', ' '));
%hold off

% save screenshot and figure file
figure(figure1)
filename = [params.img.stim_label, '-', params.filt.label, '-regionmeans'];
dir = [params.out.mainDir, params.out.patternDir, params.out.modelDir];
saveas(figure1, [dir filename '.fig'], 'fig');
saveas(figure1, [dir filename '.png'], 'png');

%close the new figure so later visualizations reuse the original figure

close(figure1)

