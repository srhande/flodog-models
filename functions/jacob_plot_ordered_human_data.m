function [  ] = jacob_plot_ordered_human_data( ordering )
%PLOT_DIFFS plots humn data in (optionally) specified order
%   5/27/14 Eric Morgan
%   8/10/14 Eric Morgan - made this version to display model data alongside
%           experimental human responses from Jacob's experiments -
%           'ordering' parameter is used to change the order of human
%           participants if necessary to make correlations easier to view




% get human data for comparison
clear datalist
load('datalist.mat');

if nargin > 0  %if we specified a specific ordering of the human data
    indexlist = ordering;                   %use that ordering
else
    indexlist = [1: size(datalist, 2)];     %otherwise just go in recorded order
end

% put human data into new container in correct order (reordered if
% necessary, default order if not)

jacobdatatemp = datalist(:, indexlist(1));

for resultindex = 2:size(datalist, 2)
    jacobdatatemp = [jacobdatatemp datalist(:, indexlist(resultindex))];
end

% subtracting the patch 2 color value from the patch 1 color value to get
% the observed difference between the colors
jacobdata = zeros(33, size(jacobdatatemp, 2));
for i=1:33
    jacobdata(i, :) = jacobdatatemp(i, :) - jacobdatatemp(i + 33, :);
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

jacobhumanlabels = {'Human #1'};
for i=2:size(jacobdata, 2)
    jacobhumanlabels = {jacobhumanlabels{:}, ['Human #', num2str(i)]};
end



% plot model responses for each model and stimulus, scaled to WE-thick (not
% scaled any more, see above)
figure;

hold all

% plot model data
for i=1:size(jacobdata, 2)
    plot(jacobdata(:, i))
    disptext = ['Human #' num2str(i)];
    disp(disptext)
    for j=1:length(jacobstimlabels)
        disptext = ['   ', jacobstimlabels{j}, '  ', num2str(jacobdata(j, i))];
        disp(disptext)
    end        
end

legend(jacobhumanlabels{:})
set(gca, 'XTick', 1:numel(jacobstimlabels))
set(gca,'XTickLabel',jacobstimlabels);
rotateXLabels( gca(), 45 )
hold off
set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window


figure;
hold all

% plot human data
bar(jacobdata)

legend(jacobhumanlabels{:})
set(gca, 'XTick', 1:numel(jacobstimlabels))
set(gca,'XTickLabel',jacobstimlabels);
rotateXLabels( gca(), 45 )
hold off
set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window







