% Use local normalization by filter orientation (filtering with a
% Guassian).  Handles model types 'odog', 'lodog', 'flodog'
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
% Eric Morgan 5/20/14
%
% function [params response] = BM_odog_lodog_flodog(filter_response, params)
function [params] = BM_odog_lodog_flodog(filter_response, params)

disp('weighting and normalizing');

params.history{length(params.history) + 1} = 'BM_odog_lodog_flodog';

% pull out some stuff from params
orientations = params.filt.orientations;
stdev_pixels = params.filt.stdev_pixels;

% to hold model output
modelOut = 0;

% loop over the orientations
for o = 1 : length(orientations)

    this_norm = 0;

    if(strcmp(params.norm.type, 'flodog') || (strcmp(params.norm.type, 'flodog2b'))) %using slightly different initial normalization for FLODOG
        % loop over spatial frequencies
        for f = 1 : length(stdev_pixels)
            
            % get the filtered response
            filt_img = filter_response{o, f};
            
            
            
            % create the proper weight
            if(params.filt.w.use)
                if(o == 1 && f == 1)
                    disp(['using w_val_slope = ' num2str(params.filt.w.valslope)]);
                end
                % keep individual frequency responses separate
                filter_response{o, f} = filt_img * params.filt.w.val(f);
                if params.out.genImages
                    filename = ['FLODOG-weighted-prenormal-', num2str(orientations(o)), ...
                        '-', num2str(stdev_pixels(f)), '.png'];
                    text = {['FLODOG Normalization, weighted, prenormalization: orientation ', ...
                        num2str(orientations(o)), ', frequency (pixels) ', ...
                        num2str(stdev_pixels(f))], ['weight = ', num2str(params.filt.w.val(f)), ...
                        ', min = ', num2str(min(min(filter_response{o, f}))), ...
                        ', max = ', num2str(max(max(filter_response{o, f})))]};
                    generate_image(filter_response{o, f}, text, filename, ...
                        [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
                end
            else
                filter_response{o, f} = filt_img;
            end
        end
    else  % for ODOG, LODOG, and UNODOG(?)
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
                    filename = ['ODOG-weighted-prenormal-', num2str(orientations(o)), ...
                        '-', num2str(stdev_pixels(f)), '.png'];
                    text = {['ODOG Normalization, weighted, prenormalization: orientation ', ...
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
            
            % weight and add over filt.stdev_pixels
            this_norm = this_norm + temp;
        end
    end

    % global normalization (ODOG)
    if(strcmp(params.norm.type, 'odog'))
        if(o == 1)
            disp('using global normalization');
        end
        
        % do normalization
        this_norm = this_norm ./ sqrt(mean(this_norm(:) .* this_norm(:)));
        
        if params.out.genImages
            filename = ['ODOG-weighted-normal-', num2str(orientations(o)), '.png'];
            text = {['ODOG Normalization, weighted and normalized: orientation ', ...
                num2str(orientations(o)), ', min = ', num2str(min(min(this_norm))), ...
                ', max = ', num2str(max(max(this_norm)))]};
            generate_image(this_norm, text, filename, ...
                [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
        end

        % combine the layers
        modelOut = modelOut + this_norm;
    end
    % local normalization by orientation (LODOG)
    if(strcmp(params.norm.type, 'lodog'))

        if(o == 1)
            disp('using local normalization by orientation');
        end

        % square
        img_sqr = this_norm .^ 2;

        %img_sqr = abs(this_norm); % take abs instead

        % extent along direction of filter - funciton of frequency
        sig1 = feval(params.norm.sig1fun, orientations(o));

        % perpendicular to filter
        sig2 = sig1 * params.norm.sr;

        % directed along main axis of filter
        rot = orientations(o) * pi/180;

        % create a unit volume gaussian for filtering
        mask = d2gauss(params.norm.x, sig1, params.norm.y, sig2, rot);
        mask = mask ./ sum(mask(:));
        
        % visualize the mask for each orientation (in case we use
        % non-circular ones later)
        if params.out.genImages
            filename = ['LODOG-mask-', num2str(orientations(o)), '.png'];
            text = {['LODOG Mask: orientation', num2str(orientations(o))]};
            generate_image(mask, text, filename, ...
                [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
        end

        % filter the image (using unit-sum mask --> mean)
        filter_out = ourconv(img_sqr, mask, 0);

        % make sure there are no negative numbers
        % min_filt_out = min(filter_out(:))
        filter_out = filter_out + params.norm.fft_adjust;

        % take the square root, last part of doing RMS
        filter_out = filter_out .^ 0.5;

        % divide through by normalized image, with additive const
        this_norm = this_norm ./ (filter_out + params.const.ADD_CONST);
        %disp(['Using additive constant of ', num2str(params.const.ADD_CONST)])
        
        %visualize the normalized filter
        if params.out.genImages
            filename = ['LODOG-normalized-weighted-', num2str(orientations(o)), '.png'];
            text = {['LODOG Normalization, weighted and normalized: orientation ', ...
                num2str(orientations(o)),', min = ', num2str(min(min(this_norm))), ...
                ', max = ', num2str(max(max(this_norm)))]};
            generate_image(this_norm, text, filename, ...
                [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
        end

        % accumulate the output
        modelOut = modelOut + this_norm;
    end
end

% frequency dependent local normalization (FLODOG)
if(strcmp(params.norm.type, 'flodog'))
    
    modelOut = 0; % just to be sure
    
    for o = 1 : length(orientations)
        if(o == 1)
            disp('using frequency dependent local normalization');
        end
        
        % variable for visualizing normalized filters
        temp_orient = 0;
        
        % loop over all frequencies
        for f = 1 : length(stdev_pixels)
            filter_resp = filter_response{o,f};
            
            % build a weighted normalizer
            normalizer = 0;
            area = 0;
            for (wf = 1 : length(stdev_pixels))
                gweight = gauss(f-wf, params.norm.sdmix);
                area = area + gweight;
                normalizer = normalizer + (filter_response{o,wf} .* gweight);
            end
            normalizer = normalizer ./ area;
            
            % square
            normalizer_sqr = normalizer .^ 2;
        
            % create the filter:
            % extent along direction of filter - funciton of frequency
            sig1 = feval(params.norm.sig1fun, stdev_pixels(f));
        
            % perpendicular to filter
            sig2 = sig1 * params.norm.sr;
        
            % directed along main axis of filter
            rot = orientations(o) * pi/180;
        
            % create a unit volume gaussian for filtering
            mask = d2gauss(params.norm.x, sig1, params.norm.y, sig2, rot);
            mask = mask ./ sum(mask(:));
            
            % visualize the mask
            if params.out.genImages
                filename = ['FLODOG-mask-', num2str(orientations(o)), '-', ...
                    num2str(stdev_pixels(f)), '.png'];
                text = {['FLODOG Mask: orientation', num2str(orientations(o)), ...
                    ', frequency (pixels) ', num2str(stdev_pixels(f))]};
                generate_image(mask, text, filename, ...
                    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
            end

        
            % filter the image (using unit-sum mask --> mean)
            local_normalizer = ourconv(normalizer_sqr, mask, 0);
        
            % make sure there are no negative numbers
            local_normalizer = local_normalizer + params.norm.fft_adjust;
        
            % take the square root, last part of doing RMS
            local_normalizer = local_normalizer .^ 0.5;
        
            % divide through by normalized image, with additive const
            temp = filter_resp ./ (local_normalizer + params.const.ADD_CONST);
            %disp(['Using additive constant of ', num2str(params.const.ADD_CONST)])
            
            % visualize the per-requency normalized filter
            if params.out.genImages
                filename = ['FLODOG-normalize-weighted-perfreq-', ...
                    num2str(orientations(o)), '-', num2str(stdev_pixels(f)), '.png'];
                text = {['FLODOG Normalization, weighted and normalized: orientation ', ...
                    num2str(orientations(o)), ', frequency (pixels) ', ...
                    num2str(stdev_pixels(f))], ['weight = ', num2str(gweight), ...
                    ', min = ', num2str(min(min(temp))), ', max = ', num2str(max(max(temp)))]};
                generate_image(temp, text, filename, ...
                    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
            end
        
            % accumulate the output
            modelOut = modelOut + temp;
            temp_orient = temp_orient + temp;
        end

        
        if params.out.genImages
            filename = ['FLODOG-normalize-weighted-', num2str(orientations(o)), '.png'];
            text = {['FLODOG Normalization, weighted, normalized, and combined: orientation ', ...
                num2str(orientations(o)), ', min = ', num2str(min(min(temp_orient))), ...
                ', max = ', num2str(max(max(temp_orient)))]};
            generate_image(temp_orient, text, filename, ...
                [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
        end
    end
end

% frequency dependent local normalization (FLODOG2b)
if(strcmp(params.norm.type, 'flodog2b'))
    
    modelOut = 0; % just to be sure
    
    for o = 1 : length(orientations)
        if(o == 1)
            disp('using frequency dependent local normalization');
        end
        
        % variable for visualizing normalized filters
        temp_orient = 0;
        
        % loop over all frequencies and orientations
        
        for f = 1 : length(stdev_pixels)
            filter_resp = filter_response{o,f};
            % build a weighted normalizer
            normalizer = 0;
            area = 0;
            for wf = 1 : length(stdev_pixels)
                gweight = gauss(f-wf, params.norm.sdmix(1));
                area = area + gweight;
                oarea = 0;
                onormalizer = 0;
                for wo = 1 : length(orientations)
                    ogweight = gauss(o-wo, params.norm.sdmix(2));
                    oarea = oarea + ogweight;
                    onormalizer = onormalizer + (filter_response{wo, wf} .* ogweight);
                end
                onormalizer = onormalizer ./ oarea;
                onormalizer = onormalizer .* gweight;
                % create the filter:
                % extent along direction of filter - function of frequency
                sig1 = feval(params.norm.sig1fun, stdev_pixels(wf));
                
                % perpendicular to filter
                sig2 = sig1 * params.norm.sr;
                
                % directed along main axis of filter
                rot = orientations(o) * pi/180;
                
                % create a unit volume gaussian for filtering
                mask = d2gauss(params.norm.x, sig1, params.norm.y, sig2, rot);
                mask = mask ./ sum(mask(:));
                
                onormalizer = ourconv(onormalizer, mask, 0);
                normalizer = normalizer + onormalizer;
            end
            normalizer = normalizer ./ area;
            normalizer_sqr = normalizer .^ 2;
            % make sure there are no negative numbers
            local_normalizer = normalizer_sqr + params.norm.fft_adjust;
            
            % take the square root, last part of doing RMS
            local_normalizer = local_normalizer .^ 0.5;
            
            % visualize the normalizer
            if params.out.genImages
                filename = ['FLODOG2b-normvals-', num2str(orientations(o)), '-', ...
                    num2str(stdev_pixels(f)), '.png'];
                text = {['FLODOG2b normalizing values: orientation', num2str(orientations(o)), ...
                    ', frequency (pixels) ', num2str(stdev_pixels(f))], ...
                    ['max = ', num2str(max(local_normalizer(:)))]};
                generate_image(local_normalizer, text, filename, ...
                    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
            end

        
            % divide through by normalized image, with additive const
            temp = filter_resp ./ (local_normalizer + params.const.ADD_CONST);
            %disp(['Using additive constant of ', num2str(params.const.ADD_CONST)])
            
            % visualize the per-requency normalized filter
            if params.out.genImages
                filename = ['FLODOG2b-normalized-weighted-perfreq-', ...
                    num2str(orientations(o)), '-', num2str(stdev_pixels(f)), '.png'];
                text = {['FLODOG2b Normalization, weighted and normalized: orientation ', ...
                    num2str(orientations(o)), ', frequency (pixels) ', ...
                    num2str(stdev_pixels(f))], ['weight = ', num2str(gweight), ...
                    ', min = ', num2str(min(min(temp))), ', max = ', num2str(max(max(temp)))]};
                generate_image(temp, text, filename, ...
                    [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
            end
        
            % accumulate the output
            modelOut = modelOut + temp;
            temp_orient = temp_orient + temp;
        end

        
        if params.out.genImages
            filename = ['FLODOG2b-normalized-weighted-', num2str(orientations(o)), '.png'];
            text = {['FLODOG2b Normalization, weighted, normalized, and combined: orientation ', ...
                num2str(orientations(o)), ', min = ', num2str(min(min(temp_orient))), ...
                ', max = ', num2str(max(max(temp_orient)))]};
            generate_image(temp_orient, text, filename, ...
                [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
        end
    end
end



% place the results into the params struct
params.out.img = modelOut;

% visualize final model
if(strcmp(params.norm.type, 'odog'))
    filename = ['ODOG-final-model.png'];
    text = {['ODOG Normalization: Final Model']};
    generate_image(modelOut, text, filename, ...
        [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
elseif(strcmp(params.norm.type, 'lodog'))
    filename = ['LODOG-final-model.png'];
    text = {['LODOG Normalization: Final Model']};
    generate_image(modelOut, text, filename, ...
        [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
elseif(strcmp(params.norm.type, 'flodog'))
    filename = ['FLODOG-final-model.png'];
    text = {['FLODOG Normalization: Final Model']};
    generate_image(modelOut, text, filename, ...
        [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
elseif(strcmp(params.norm.type, 'flodog2b'))
    filename = ['FLODOG2B-final-model.png'];
    text = {['FLODOG2B Normalization: Final Model']};
    generate_image(modelOut, text, filename, ...
        [params.out.mainDir, params.out.patternDir, params.out.modelDir], 'jet')
end


end
