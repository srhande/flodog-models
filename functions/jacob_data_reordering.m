function [  ] = jacob_data_reordering(  )
%PLOT_DIFFS takes as input key/value mapping of diffs and plots them
%   5/27/14 Eric Morgan
%   8/10/14 Eric Morgan - made this version to display model data alongside
%           experimental human responses from Jacob's experiments -
%           'ordering' parameter is used to change the order of human
%           participants if necessary to make correlations easier to view



% get human data
clear datalist
load('datalist.mat');


% put human data into new container in correct order (reordered if
% necessary, default order if not)



% subtracting the patch 2 color value from the patch 1 color value to get
% the observed difference between the colors
jacobdata = zeros(33, size(datalist, 2));
for i=1:33
    jacobdata(i, :) = datalist(i, :) - datalist(i + 33, :);
end

jacobstimlabels = {...
    'Whites', 'Howe var B', 'Howe', 'Howe var D', 'SBC', 'Anderson', ...
    'Rings', 'Radial', 'Zigzag', 'Jacob 1', 'Jacob 2', ...
    'Whites (DI)', 'Howe var B (DI)', 'Howe (DI)', 'Howe var D (DI)', ...
    'SBC (DI)', 'Anderson (DI)', 'Rings (DI)', 'Radial (DI)', 'Zigzag (DI)', ...
    'Jacob 1 (DI)', 'Jacob 2 (DI)', ...
    'Whites (DD)', 'Howe var B (DD)', 'Howe (DD)', 'Howe var D (DD)', 'SBC (DD)', ...
    'Anderson (DD)', 'Rings (DD)', 'Radial (DD)', 'Zigzag (DD)', 'Jacob 1 (DD)', ...
    'Jacob 2 (DD)'...
    };

% jacobhumanlabels = {'Human #1'};
% for i=2:size(jacobdata, 2)
%     jacobhumanlabels = {jacobhumanlabels{:}, ['Human #', num2str(i)]};
% end

allsortorders = [];

for i=1:numel(jacobstimlabels)
    stimName = jacobstimlabels{i};
    
    %reorder human data in descending order based on current stim's results
    datatemp = [jacobdata', [1:size(datalist, 2)]'];
    datatemp = sortrows(datatemp, i);
    sortorder = datatemp(:, end);
    datatemp = datatemp(:, 1:end-1);
    datatemp = datatemp';
    
    allsortorders = [allsortorders, sortorder];
    
    
    jacobhumanlabels = {};
    for j=1:numel(sortorder)
        jacobhumanlabels = {jacobhumanlabels{:}, ['Human #', num2str(sortorder(j))]};
    end
    
    
    fig = figure;
    title([stimName, ' ordered view']);
    hold all
    
    bar(datatemp)

    legend(jacobhumanlabels{:})
    set(gca, 'XTick', 1:numel(jacobstimlabels))
    set(gca,'XTickLabel',jacobstimlabels);
    rotateXLabels( gca(), 45 )
    hold off
    set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window
    
    filename = [jacobstimlabels{i}, '-ordered sort'];
    dir = './output/jacobdata/human_data_ordering/';
    
    if(~exist(dir, 'dir'))
        mkdir(dir);
    end
    
    saveas(fig, [dir filename '.fig'], 'fig');
    saveas(fig, [dir filename '.png'], 'png');
    close(fig)
    
 end
 histfig = figure;
%  hold all
%  for k=size(allsortorders, 1)
%      column = allsortorders(k, :);
%      hist(column, size(allsortorders, 2));
%  end
allsortorders_t = allsortorders';
centers = 1:size(datalist, 2);
counts = hist(allsortorders_t, size(datalist, 2));
bar(centers, counts)
%set(gca, 'XTick', 1:(size(datalist, 2)));
legend_labels = {};
for x=1:size(datalist, 2)
    legend_labels = {legend_labels{:}, [ iptnum2ordinal(x), ' highest value']};
end
legend(legend_labels)
 

