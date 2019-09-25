% Compute the average activation over regions specified in
% params.out.regions
%
% INPUT:    params - a structure of parameters describing how to normalize
%           see set_wn_params.m and the function to create the stimulus
%
% Paul Hammon 10/15/04
%
% Revision History:
% 1/13/04 -- changed to use the new parameter structure, which gives a mask
% with the different regions to compute the average over labelled
% 3-13-05 == adeed min, max, and std deviation (AER).
% 7/12/05 -- (PH) updated for new params setup

function params = BM_proc_regions(params)

params.history{length(params.history) + 1} = 'BM_proc_regions';

if (eval('params.img.labeled_regions;','0') == 0)
    return; % do nothing if no labled regions 
end

regions = [];
ind = 1;
max_region = max(params.img.labeled_regions(:));
% region_copy = params.img.labeled_regions;

% compute and save the region statistics
for i = 1 : max_region
    if find(params.img.labeled_regions == i) % skip discontinueous labled regions
        params.out.regions.mean(i) = mean(params.out.img(find(params.img.labeled_regions == i)));
        params.out.regions.max(i) = max(params.out.img(find(params.img.labeled_regions == i)));
        params.out.regions.min(i) = min(params.out.img(find(params.img.labeled_regions == i)));
        params.out.regions.stdev(i) = std(params.out.img(find(params.img.labeled_regions == i)));
        % region_copy(find(params.img.labeled_regions == i)) = params.out.regions.mean(i);
    end
end


% % add the updated labeled_regions and the region values into the struct
% params.out.mean_regions = region_copy;
% params.out.regions = regions;