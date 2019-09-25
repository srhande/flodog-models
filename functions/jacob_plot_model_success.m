function [  ] = jacob_plot_model_success( diff_results, params, ordering )
%PLOT_DIFFS takes as input key/value mapping of diffs and plots them
%   5/27/14 Eric Morgan
%   8/10/14 Eric Morgan - made this version to display model data alongside
%           experimental human responses from Jacob's experiments -
%           'ordering' parameter is used to change the order of human
%           participants if necessary to make correlations easier to view


stims = keys(diff_results);  %get list of stimulus names (keys)
num_stims = length(stims);
models = keys(diff_results(stims{1})); %get list of models (should be the same for all stimuli)
num_models = length(models);
stims_labels = {};  %used to allow for adding names in case of multiple pairs of test patches for a stimulus

X_vals = zeros(num_models, num_stims);  % one row for each model, one column for each stimulus
Y_vals = zeros(num_models, num_stims);
Y_diff_vals = zeros(num_models, num_stims);


% get human data for comparison
clear datalist
load('datalist.mat');

if nargin > 2  %if we specified a specific ordering of the human data
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



for curr_stim=1:numel(jacobstimlabels)
    
    % extract the model diff values
    model_results = diff_results(jacobstimlabels{curr_stim});
    
    model_count = 1;
    
    %stims_labels = {stims_labels{:}, stims{curr_stim}};

%     if isKey(human_data, stims{curr_stim})
%         human_response = human_data(stims{curr_stim});
%     else
%         human_response = 0;
%     end
    
    for curr_model=1:num_models
        
        curr_model_key = models{curr_model};
        
        %extract WE_thick value if present for results scaling (this is
        %invalid in Jacob's data, but kept here in case we want to
        %scale based on a stimulus that is present
        if isKey(diff_results, 'WE-thick')
            temp = diff_results('WE-thick');
            scale_factor = abs(temp(curr_model_key));
        else
            scale_factor = 1; %don't scale if WE-thick not present
        end
        
        mod_diff_vals = model_results(curr_model_key);
        
        %         if length(mod_diff_vals) == 1  %if only one test pair, put it in its slot
        X_vals(model_count, curr_stim) = curr_stim;
        Y_vals(model_count, curr_stim) = mod_diff_vals / scale_factor;
        %Y_diff_vals(model_count, curr_stim) = (mod_diff_vals / scale_factor) / human_response;
        model_count = model_count + 1;
        %         else
        %             for x=1:length(mod_diff_vals) %otherwise make room for more than one pair for that stim
        %                 if x == 1
        %                     stims_labels{end} = [stims_labels{end}, '-1'];
        %                 else
        %                     stimname = [stims{curr_stim}, '-', num2str(x)];
        %                     stims_labels = {stims_labels{:}, stimname};
        %                 end
        %                 X_vals = [X_vals, zeros(num_models, 1)];
        %                 Y_vals = [Y_vals, zeros(num_models, 1)];
        %                 X_vals(model_count, curr_stim) = curr_stim;
        %                 Y_vals(model_count, curr_stim) = mod_diff_vals(x) / scale_factor;
        %                 Y_diff_vals(model_count, curr_stim) = (mod_diff_vals(x) / scale_factor) / human_response;
        %                 model_count = model_count + 1;
        %             end
        %end
    end
    

end


% prep data to make it proportional rather than absolute (divide each
% response value by the max response value)
Y_vals_t = Y_vals';
jacobdatarelative = zeros(size(jacobdata));
for i=1:size(Y_vals_t, 1)
    Y_vals_t(i, :) = Y_vals_t(i, :) ./ max(abs(Y_vals_t(:)));
    jacobdatarelative(i, :) = jacobdata(i, :) ./ max(abs(jacobdata(:)));
end

dir = [params.out.mainDir, 'ind_results/'];
if(~exist(dir, 'dir'))
    mkdir(dir);
end

% for each human subject, count how many stimuli each model gets the
% correct dimension for

model_correct_vals_count = zeros(size(jacobdata, 2), num_models);
model_correct_vals_amount = zeros(size(jacobdata, 2), num_models);
for subjectindex=1:size(jacobdata, 2)
    for modelindex = 1:num_models
        modelvals = Y_vals_t(:, modelindex);
        humanvals = jacobdatarelative(:, subjectindex);
        correctcount = 0;
        correctvalue = 0;
        for i = 1:numel(modelvals)
            if (sign(modelvals(i)) == sign(humanvals(i)))
                correctcount = correctcount + 1;
                correctvalue = correctvalue + abs(modelvals(i) - humanvals(i));
            end
        end
        model_correct_vals_count(subjectindex, modelindex) = correctcount;
        model_correct_vals_amount(subjectindex, modelindex) = correctvalue;
    end
end

% plot all subjects
mod_correct_fig = figure;
title('Number of correct illusions per model')
hold all
for i=1:size(jacobdata, 2)
    plot(model_correct_vals_count(i, :))
end
legend(jacobhumanlabels)
set(gca, 'XTick', 1:num_models)
set(gca,'XTickLabel',models);
if verLessThan('matlab', '8.4.0')
    rotateXLabels( gca(), 45 )
else
    ax = gca;
    ax.XTickLabelRotation = 45;
end
hold off
set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window

%save the graph if params is specified
if nargin > 1
    filename = 'ModelCorrectCount';
    saveas(mod_correct_fig, [dir filename '.fig'], 'fig');
    saveas(mod_correct_fig, [dir filename '.png'], 'png');
end
close(mod_correct_fig);

% plot individual subjects separately
for subjectindex = 1:size(jacobdata, 2)
    mod_correct_fig_persub = figure;
    hold all
    subplot(2,1,1)
    title(['Number of correct illusion directions per model for ', jacobhumanlabels{subjectindex}])
    plot(model_correct_vals_count(subjectindex, :))
    set(gca, 'XTick', 1:num_models)
    set(gca,'XTickLabel',models);
    if verLessThan('matlab', '8.4.0')
        rotateXLabels( gca(), 45 )
    else
        ax = gca;
        ax.XTickLabelRotation = 45;
    end
    
    subplot(2,1,2)
    plot(model_correct_vals_amount(subjectindex, :))
    %legend(jacobhumanlabels)
    set(gca, 'XTick', 1:num_models)
    set(gca,'XTickLabel',models);
    if verLessThan('matlab', '8.4.0')
        rotateXLabels( gca(), 45 )
    else
        ax = gca;
        ax.XTickLabelRotation = 45;
    end
    hold off
    set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window

    %save the graph if params is specified
    if nargin > 1
        filename = ['ModelCorrectCount_', num2str(subjectindex)];
        saveas(mod_correct_fig_persub, [dir filename '.fig'], 'fig');
        saveas(mod_correct_fig_persub, [dir filename '.png'], 'png');
    end
    close(mod_correct_fig_persub);
end




end