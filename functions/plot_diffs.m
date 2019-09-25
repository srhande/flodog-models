function [  ] = plot_diffs( diff_results, params )
%PLOT_DIFFS takes as input key/value mapping of diffs and plots them
%   5/27/14 Eric Morgan


stims = keys(diff_results);  %get list of stimulus names (keys)
num_stims = length(stims);
models = keys(diff_results(stims{1})); %get list of models (should be the same for all stimuli)
num_models = length(models);
stims_labels = {};  %used to allow for adding names in case of multiple pairs of test patches for a stimulus

X_vals = zeros(num_models + 1, num_stims);  % one row for each model plus one for human data, one column for each stimulus
Y_vals = zeros(num_models + 1, num_stims);
Y_diff_vals = zeros(num_models, num_stims);

% get human data for comparison
human_data = get_human_data();

for curr_stim=1:num_stims
    
    % extract the model diff values
    model_results = diff_results(stims{curr_stim});
    
    model_count = 1;
    
    stims_labels = {stims_labels{:}, stims{curr_stim}};

    if isKey(human_data, stims{curr_stim})
        human_response = human_data(stims{curr_stim});
    else
        human_response = 1;
    end
    
    for curr_model=1:num_models
        
        curr_model_key = models{curr_model};
        
        %extract WE_thick value if present for results scaling
        if isKey(diff_results, 'WE-thick')
            temp = diff_results('WE-thick');
            scale_factor = abs(temp(curr_model_key));
        else
            scale_factor = 1; %don't scale if WE-thick not present
        end

        mod_diff_vals = model_results(curr_model_key);
        
        if length(mod_diff_vals) == 1  %if only one test pair, put it in its slot
            X_vals(model_count, curr_stim) = curr_stim;
            Y_vals(model_count, curr_stim) = mod_diff_vals / scale_factor;
            Y_diff_vals(model_count, curr_stim) = (mod_diff_vals / scale_factor) / human_response;
            model_count = model_count + 1;
        else
            for x=1:length(mod_diff_vals) %otherwise make room for more than one pair for that stim
                if x == 1
                    stims_labels{end} = [stims_labels{end}, '-1'];
                else
                    stimname = [stims{curr_stim}, '-', num2str(x)];
                    stims_labels = {stims_labels{:}, stimname};
                end
                X_vals = [X_vals, zeros(num_models, 1)];
                Y_vals = [Y_vals, zeros(num_models, 1)];
                X_vals(model_count, curr_stim) = curr_stim;
                Y_vals(model_count, curr_stim) = mod_diff_vals(x) / scale_factor;
                Y_diff_vals(model_count, curr_stim) = (mod_diff_vals(x) / scale_factor) / human_response;
                model_count = model_count + 1;
            end
        end
    end
    
    % add human response data for each stim
    if isKey(human_data, stims(curr_stim))
    	X_vals(end, curr_stim) = curr_stim;
    	Y_vals(end, curr_stim) = human_data(stims{curr_stim});
    end


end

% % plot model responses for each model and stimulus, scaled to WE-thick
% resultplot = figure;
% title([params.out.figTitle, ' - raw results']);
% hold all
% 
% % plot model data
% for i=1:num_models
%     plot(Y_vals(i, :))
%     disptext = [models{i}, ': '];
%     disp(disptext)
%     for j=1:length(stims_labels)
%         disptext = ['   ', stims_labels{j}, '  ', num2str(Y_vals(i, j))];
%         disp(disptext)
%     end        
% end
% 
% % plot human data
% plot(Y_vals(end, :))
% 
% legend({models{:}, 'Human Response'})
% set(gca, 'XTick', 1:numel(stims_labels))
% set(gca,'XTickLabel',stims_labels);
% if verLessThan('matlab', '8.4.0')
%     rotateXLabels( gca(), 45 )
% else
%     ax = gca;
%     ax.XTickLabelRotation = 45;
% end
% % add centerline at 0
% refline(0,0)
% 
% hold off
% set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window
% 
% %save the graph if params is specified
% if nargin > 1
%     filename = 'results_graph';
%     dir = params.out.mainDir;
%     saveas(resultplot, [dir filename '.fig'], 'fig');
%     saveas(resultplot, [dir filename '.png'], 'png');
% end
% 
% % plot differences between model response and human response for each
% % stimulus
% diffplot = figure;
% title([params.out.figTitle, ' - results divided by human data']);
% hold all

% % plot model data
% for i=1:num_models
%     plot(Y_diff_vals(i, :))
%     disptext = [models{i}, ': '];
%     disp(disptext)
%     for j=1:length(stims_labels)
%         disptext = ['   ', stims_labels{j}, '  ', num2str(Y_vals(i, j))];
%         disp(disptext)
%     end        
% end
% 
% legend(models)
% set(gca, 'XTick', 1:numel(stims_labels))
% set(gca,'XTickLabel',stims_labels);
% if verLessThan('matlab', '8.4.0')
%     rotateXLabels( gca(), 45 )
% else
%     ax = gca;
%     ax.XTickLabelRotation = 45;
% end
% % add centerline at 0
% refline(0,0)
% 
% hold off
% set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window
% 
% %save the graph if params is specified
% if nargin > 1
%     filename = 'results_difference_graph';
%     dir = params.out.mainDir;
%     saveas(diffplot, [dir filename '.fig'], 'fig');
%     saveas(diffplot, [dir filename '.png'], 'png');
% end

barresultplot = figure;
title([params.out.figTitle, ' - raw results']);
hold all
Y_vals_t = Y_vals';
bar(Y_vals_t)
legend({models{:}, 'Human Response'})
set(gca, 'XTick', 1:numel(stims_labels))
set(gca,'XTickLabel',stims_labels);
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
    filename = 'results_bar_graph';
    dir = params.out.mainDir;
    saveas(barresultplot, [dir filename '.fig'], 'fig');
    saveas(barresultplot, [dir filename '.png'], 'png');
end

% bardiffplot = figure;
% title([params.out.figTitle, ' - results divided by human data']);
% hold all
% Y_diff_vals_t = Y_diff_vals';
% bar(Y_diff_vals_t)
% legend(models{:})
% set(gca, 'XTick', 1:numel(stims_labels))
% set(gca,'XTickLabel',stims_labels);
% if verLessThan('matlab', '8.4.0')
%     rotateXLabels( gca(), 45 )
% else
%     ax = gca;
%     ax.XTickLabelRotation = 45;
% end
% hold off
% set(gcf,'units','normalized','outerposition',[0 0 1 1])  %maximize the figure window
% 
% %save the graph if params is specified
% if nargin > 1
%     filename = 'results_difference_bar_graph';
%     dir = params.out.mainDir;
%     saveas(bardiffplot, [dir filename '.fig'], 'fig');
%     saveas(bardiffplot, [dir filename '.png'], 'png');
% end


