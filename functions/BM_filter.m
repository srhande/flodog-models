% Create the BM filtered images using best guess at 
% BM approach from the '99 BM paper.
% 
% INPUT : params - structure of parameters for this run.  Specifically,
%                  allows for use of unit normalized filters.  Includes the
%                  image to process as params.image
% OUTPUT: filt - a structure of filter responses, stdev_pixels,
%                and orientations
%
% Paul Hammon 10/1/04  -- based on original code by Micah Richert
%
% Revision History:
% 10/11/04 -- added option to take params struct; adds original image to
%             filt structure
% 10/13/04 -- removed original image from filt stucture, added to params
% 10/15/04 -- fixed so that params.img.image contains the image to filter
% 10/20/02 -- changed image name to params.img.img
% 10/22/04 -- now displays whether or not using normalized filters
% 3-9-05 AER -- now actually uses unit norm filters
% 7-1-05 AER -- option to use gabor filters, commented out
% 7/12/05 -- (PH) modified to use updated params struct
% 8/12/05 -- (AR) now uses .5 for image padding, not mean.
% 5/20/14 -- (EM) added visualization of filters and filter responses

% function filter_response = BM_filter(params)
function [params, filter_response] = BM_filter(params)


disp('generating filters');

% update history
params.history{length(params.history) + 1} = 'BM_filter';

% pull out useful information from params
orientations = params.filt.orientations;
stdev_pixels = params.filt.stdev_pixels;

% create a cell array to put things into
filter_response = cell(length(orientations), length(stdev_pixels));

if(params.filt.norm)
    disp('using unit norm filters');
end

% loop over orientations
for o = 1 : length(orientations)
    
    disp(['orientation = ' num2str(o)]);
    
    % loop over frequencies
    for f = 1 : length(stdev_pixels)
        
        % create the filter
        filter = dogEx(params.filt.y, params.filt.x, stdev_pixels(f) * params.filt.stretchWidth, ...
            stdev_pixels(f), params.filt.negwidth, params.filt.neglen, orientations(o) * pi/180, params.filt.centerW);   
    
         % plot the filter
         % plot(filter(512,:));xlim([0 1024]); axis off;
                      
        % normalize the filters if flag set in params
        if(params.filt.norm)
            filter = filter ./ norm(filter(:)); % unit norm
        end
        
        %visualize filter
        if params.out.genImages
            img_txt = {['Initial Filter: orientation ', num2str(orientations(o)), ...
                ', frequency (pixels) ', num2str(stdev_pixels(f))], ...
                ['min = ', num2str(min(min(filter))), ...
                ', max = ', num2str(max(max(filter)))]};
            filename = ['filter-', ...
                num2str(orientations(o)), '-', num2str(stdev_pixels(f)), '.png'];
            generate_image(filter, img_txt, filename, [params.out.mainDir params.out.patternDir], 'jet')
        end
            
        
        % get filter response and save it
        filter_response{o, f} = ourconv(params.img.img, filter, 0.5);  % pad image with gray
        
        %visualize filter response to test pattern
        if params.out.genImages
            temp_filter_response = filter_response{o,f};
            img_txt = {['Initial Filter Response: orientation ', num2str(orientations(o)), ...
                ', frequency (pixels) ', num2str(stdev_pixels(f))], ...
                ['min = ', num2str(min(min(temp_filter_response))), ...
                ', max = ', num2str(max(max(temp_filter_response)))]};
            filename = ['filterresponse-', num2str(orientations(o)), '-', ...
                num2str(stdev_pixels(f)), '.png'];
            generate_image(temp_filter_response, img_txt, filename, [params.out.mainDir params.out.patternDir], 'jet')
            clear temp_filter_response
        end
        clear filter;

        
    end
    
end
