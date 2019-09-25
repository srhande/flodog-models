% Use local normalization by filter orientation (filtering with a
% Guassian).
% Local regions can be isotropic or elongated parallel or perpendicular to
% the filter orientation.
% Uses the (best guess) at the weights originally from the BM '99 paper.
%
% INPUT: filter_response - a structure of filter responses, stdev_pixels,
%                and orientations from BM_filter.m
%        params - a structure of parameters describing how to normalize
%                 see set_wn_params.m
%        (optional) save_filts - set to 1 if you want orientation filters
%                saved and returned. defaults to 0
% OUTPUT: modelOut - the output of the model with global normalization
%                   by orientation
%
% Paul Hammon 10/8/04
%
% Revision History:
% 10/11/04 -- cleaned up some hight and width stuff; added debug printouts
% 10/22/04 -- fixed an error with local normalization by orientation code
% 11/03/04 -- changed the local normalization by orientation to take the
% orientation of the filter as an argument instead of the filter stdev,
% which didn't make any sense
% 11/03/04 -- fixed (I think) the bug for local norm w/in orientation
% 7/8/05 -- added an output from the pooled and normalized orientation
%           filters -- puts normalized filters back into filter_response
%           and returns that. for 'freq' each will be returned, for
%           'local_o', only the settings for f = 1 (filter_reponse{:, 1})
%           are of interest.
% 7/12/05 -- (PH) updated for newer params; also fixed a bug when no w is used
%            (PH) also added in additive constant to normalization
%            (PH) also modified 'freq' option to store the normalized
%                 filters
% 8/10/05 -- (PH) fixed fequency normalization to use the weighted
%            filters
%
% 9/2/05 == tells ourconv what sort of padding to use (0).
% 9/26/05 -- (PH) now computes response normalization filters if you want
% 6/12/06 -- (PH) simple version of ODOG without any normalization at all
%
% function [params response] = BM_wn_unodog(filter_response, params)
function [params response] = BM_wn_unodog(filter_response, params)

response = [];

disp('weighting and normalizing');
disp('performing un-normalized ODOG (UNODOG)');

params.history{length(params.history) + 1} = 'BM_wn_unodog';

% conversion constants
DEG_PER_PIXEL = params.const.DEG_PER_PIXEL;
STD_TO_SPACE_CONST = 1 / params.const.SPACE_CONST_TO_STD;
SPACE_CONST_TO_WIDTH = params.const.SPACE_CONST_TO_WIDTH;

% pull out some stuff from params
orientations = params.filt.orientations;
stdev_pixels = params.filt.stdev_pixels;

% to hold model output
modelOut = 0;

% loop over the orientations
for o = 1 : length(orientations)

    % loop over spatial frequencies
    for f = 1 : length(stdev_pixels)

        % get the filtered response
        filt_img = filter_response{o, f};

        % create the proper weight
        if(params.filt.w.use)

            if(o == 1 && f == 1)
                disp(['using w_val_slope = ' num2str(params.filt.w.valslope)]);
            end
            
            temp = filt_img * params.filt.w.val(f);
            if params.out.genImages
                filename = ['UNODOG-weighted-', num2str(orientations(o)), ...
                    '-', num2str(stdev_pixels(f)), '.png'];
                text = {['UNODOG Normalization, weighted: orientation ', ...
                    num2str(orientations(o)), ', frequency (pixels) ', ...
                    num2str(stdev_pixels(f))], ['weight = ', num2str(params.filt.w.val(f)), ...
                    ', min = ', num2str(min(min(temp))), ...
                    ', max = ', num2str(max(max(temp)))]};
                generate_image(temp, text, filename, ...
                    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
            end
        else
            temp = filt_img;
        end
        
        % add in normalized image
        modelOut = modelOut + temp;

    end

end

filename = ['UNODOG-final-model.png'];
text = {['UNODOG Normalization: Final Model']};
generate_image(modelOut, text, filename, ...
    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')


% place the results into the params struct
params.out.img = modelOut;

