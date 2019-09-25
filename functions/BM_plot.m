% Plot horizontal or veritcal cross-sections through the image according to
% the settings in params.img.
%
% INPUT:    params - a structure of parameters describing how to normalize
%           see set_wn_params.m and the function to create the stimulus
%
% Paul Hammon 10/15/04
%
% Revision History:
% 11/10/04 -- Added title info and check for possible settings member
%          -- changed title information
% 3-13-05 -- xlimit used to make plots more tight
% 7/12/05 -- (PH) updated for newer params. just added history item
% 7-13-05 == (AR) added lazy file picker option when called with no args
% 7-13-05 == (AR) picker now puts loaded params into the workspace
function BM_plot(params)

if (nargin < 1 )
    save_dir = pwd;
    persistent ui_path; % make uiload path sticky
    eval('cd(ui_path)',''); % catch error if ui_path not defined yet
    [f  ui_path] = uigetfile('*.mat');
   file_name = strcat(ui_path,f);
   load (file_name);
   assignin('base', 'params', params);
   cd(save_dir)
   genImages = 1;
else
    genImages = params.out.genImages;
end

params.history{length(params.history) + 1} = 'BM_plot';

[r, c] = size(params.img.img);

% plot the output of the model
h = figure; 
imagesc(params.out.img), colormap(gray), colorbar('vert');

% make a title string
title_str = [];
if(isfield(params.img, 'stim'))
    str = params.img.stim;
    str = strrep(str, '\', '');
    str = strrep(str, ':', '');
    str = strrep(str, '_', '\_');
    title_str = [title_str ' stim = ' str];
end
if(isfield(params.norm, 'settings'))
    str = params.norm.settings;
    str = strrep(str, '_', '\_');
    title_str = [title_str ' set = ' str];
end
title(title_str);

% plot horizonal cross-section
if(~isempty(params.img.cuty))
    x = 1 : 1 : c;
    figure(h), hold on;
    plot(x, params.img.cuty, 'm-');
    hold off;
    
    h2 = figure;
    
    plot(x, params.out.img(params.img.cuty, :), 'r', x, ones(size(x)) * mean(params.out.img(:)), 'b-.'), grid on;
    title([title_str ', cut y = ' num2str(params.img.cuty)]);  
    
    xlim ([0 params.img.size.w]);

    % save screenshot and figure file
    figure(h2)
    filename = [params.img.stim_label, '-', params.filt.label, '-horiz'];
    dir = [params.out.mainDir, params.out.patternDir, params.out.modelDir];
    if genImages  %only save the full figure if genimages is specified (to save disk space)
        saveas(h2, [dir filename '.fig'], 'fig');
    end
    saveas(h2, [dir filename '.png'], 'png');

    %close the new figure so later visualizations reuse the original figure
    close(h2)
end

% plot a vertical cross-section 
if(~isempty(params.img.cutx))
    x = 1 : 1 : c;
    y = 1 : 1 : r;
    x1 = ones(size(y)) *  params.img.cutx;
    figure(h), hold on;
    plot(x1, y, 'm-');
    hold off;
    
    h3 = figure;
    plot(y, params.out.img(:, params.img.cutx), 'r', y, ones(size(y)) * mean(params.out.img(:)), 'b-.'), grid on;
    title([title_str ', cut x = ' num2str(params.img.cutx)]);
    xlim ([0 params.img.size.w]);
    
    % save screenshot and figure file
    figure(h3)
    filename = [params.img.stim_label, '-', params.filt.label, '-vert'];
    dir = [params.out.mainDir, params.out.patternDir, params.out.modelDir];
    if genImages  %only save the full figure if genimages is specified (to save disk space)
        saveas(h3, [dir filename '.fig'], 'fig');
    end
    saveas(h3, [dir filename '.png'], 'png');
    
    %close the new figure so later visualizations reuse the original figure
    close(h3)

end

figure(h)
filename = [params.img.stim_label, '-', params.filt.label, '-cuts'];
dir = [params.out.mainDir, params.out.patternDir, params.out.modelDir];
if genImages  %only save the full figure if genimages is specified (to save disk space)
    saveas(h, [dir filename '.fig'], 'fig');
end
saveas(h, [dir filename '.png'], 'png');

%close the new figure so later visualizations reuse the original figure
close(h)
