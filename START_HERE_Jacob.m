% example BM run looping over stimuli
% all outputs are placed in the directory new_dir
%
% Revision History:
% 11/10/04 -- added stuff to write out files with images and with region
% information
% 1/14/04 -- updated it to use the new region defining paradigm
% 2-1-05 -- started to comment settings, added progress update text output
% 2/4/05 -- no longer gives warnings about making new directories
% 3/2/05 == uncomment line ~81 to speed up processing on low-memory machines.
% 7-4-05 == brief descriptions of some of the illusions.
% 7/8/05 -- (PH) now BM_wn returns normalized filters for local norm case
% 7/12/05 -- (PH) now uses the updated params settings
%            (PH) also added a new image file which stores the stat profiles
% 7-13-05 == (AR) fixed plotting error and added new example for setting
% model params.
% 8-9-05 == (AR) fixed summarize_params call to take params as an arguement.
% 8-30-05 == (AR) unix compatable path names.
% 5-7-10 == quick comment addition to make more usable
% 5-17-14 == (EM) moved all parameters to params struct
% 5-19-14 == (EM) updated random seeding code
% 5-20-14 == (EM) rearranged loop code so BM_filter only runs once per stim
% rather than once per normalization scheme
% 5-24-14 == (EM) added diff_results key/value mapping to hold differences of mean
%            test patch values for plotting
% 8-27-15 == (EM) Added new normalization method LAPDOG (Local Anti-Phase
%            normalized ODOG)

addpath('./functions');
addpath('./params');
addpath('./JacobPatterns');



% change the following to 0 to suppress creation of filter component images
genImages = 1;

% output directory for this run
mainDir = './output/testingJacob/';
if(~exist(mainDir, 'dir'))
    mkdir(mainDir);
end

diaryfilename = [mainDir, 'logfile.txt'];
diary(diaryfilename)

% set up an empty params structure
params = prep_params;

% set up constants
params = prep_const(params);

% struct to hold differences between mean test patch values for graphing
diff_results = containers.Map();


if verLessThan('matlab', '8.1.0')
    RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
else 
    RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
end

% stimuli (.m) files to run, check out make make_dual_whites for a good
% example of how it all works.  Second entry in each cell array is the
% "friendly name" of the stimulus (used for file/directory names)
stims = {
    {'make_whites_orig(params)', 'Whites'};
    {'make_whites_DI(params)', 'Whites (DI)'};
    {'make_whites_DD(params)', 'Whites (DD)'};
    {'make_howe_var_b_orig(params)', 'Howe var B'};
    {'make_howe_var_b_DI(params)', 'Howe var B (DI)'};
    {'make_howe_var_b_DD(params)', 'Howe var B (DD)'};
    {'make_howe_orig(params)', 'Howe'};
    {'make_howe_DI(params)', 'Howe (DI)'};
    {'make_howe_DD(params)', 'Howe (DD)'};
    {'make_howe_var_d_orig(params)', 'Howe var D'};
    {'make_howe_var_d_DI(params)', 'Howe var D (DI)'};
    {'make_howe_var_d_DD(params)', 'Howe var D (DD)'};
    {'make_sbc_orig(params)', 'SBC'};
    {'make_sbc_DI(params)', 'SBC (DI)'};
    {'make_sbc_DD(params)', 'SBC (DD)'};
    {'make_anderson_orig(params)', 'Anderson'};
    {'make_anderson_DI(params)', 'Anderson (DI)'};
    {'make_anderson_DD(params)', 'Anderson (DD)'};
    {'make_rings_orig(params)', 'Rings'};
    {'make_rings_DI(params)', 'Rings (DI)'};
    {'make_rings_DD(params)', 'Rings (DD)'};
    {'make_radial_orig(params)', 'Radial'};
    {'make_radial_DI(params)', 'Radial (DI)'};
    {'make_radial_DD(params)', 'Radial (DD)'};
    {'make_zigzag_orig(params)', 'Zigzag'};
    {'make_zigzag_DI(params)', 'Zigzag (DI)'};
    {'make_zigzag_DD(params)', 'Zigzag (DD)'};
    {'make_jacob_1_orig(params)', 'Jacob 1'};
    {'make_jacob_1_DI(params)', 'Jacob 1 (DI)'};
    {'make_jacob_1_DD(params)', 'Jacob 1 (DD)'};
    {'make_jacob_2_orig(params)', 'Jacob 2'};
    {'make_jacob_2_DI(params)', 'Jacob 2 (DI)'};
    {'make_jacob_2_DD(params)', 'Jacob 2 (DD)'};
    };


norm_settings = {...
    {'odog', '0', '0', params.const.ADD_CONST, 'ODOG'} % odog
    {'lodog',  '128',   1, params.const.ADD_CONST, 'LODOG-128NrmlSize-round'} % lodog
%     {'lodog',  '64',   1, params.const.ADD_CONST, 'LODOG-64NrmlSize-round'}
%     {'lodog',  '32',   1, params.const.ADD_CONST, 'LODOG-32NrmlSize-round'},
    {'unodog', '0', '0', 10^(-6), 'UNODOG'}
%     {'lapdog', '', 1, params.const.ADD_CONST, 'LAPDOG-e1'} % lapdog, not sure if the params matter yet
%     {'lapdog', '', 0.5, params.const.ADD_CONST, 'LAPDOG-e0.5'} % lapdog, not sure if the params matter yet
%     {'lapdog', '', 2, params.const.ADD_CONST, 'LAPDOG-e2'} % lapdog, not sure if the params matter yet
    {'flodog', '4*x', 1, 10^(-6), 0.5, 'FLODOG-4s-m0.5'} % flodog very local freq (n=4s, m=0.5)
%      {'flodog', '2*x', 1, 10^(-6), 0.5, 'FLODOG-2s-m0.5'} % flodog very local freq (n=2s, m=0.5)
%      {'flodog', '4*x', 1, 10^(-6), 3, 'FLODOG-4s-m3'} % flodog, includes nearby freq (n=4s, m=3)
%      {'flodogp', '4*x', 1, 10^(-6), 0.5, 'FLODOGP-4s-m0.5'} % flodog very local freq (n=4s, m=0.5)
%      {'flodogp', '2*x', 1, 10^(-6), 0.5, 'FLODOGP-2s-m0.5'} % flodog very local freq (n=2s, m=0.5)
%      {'flodogp', '4*x', 1, 10^(-6), 3, 'FLODOGP-4s-m3'} % flodog, includes nearby freq (n=4s, m=3)
   {'flodog2b', '2*x', 1, 10^(-6), [3, 3], 'FLODOG2-2s-m3-3'} % flodog, includes nearby freq (n=4s, m=3)
%     {'flodog2b', '4*x', 1, 10^(-6), [0.5, 0.5], 'FLODOG2-4s-m0.5-0.5'} % flodog very local freq (n=4s, m=0.5)
   };


tic


for i = 1 : length(stims)
    
    % prep the image information
    params = prep_img(params, stims{i}{1}); %#ok<*IJCL>
    
    %speed up processing for low-memory machines by using
    %single-percision floating point values
    params.img.img = single(params.img.img);
    
    % save the stim "friendly" name
    params.img.stim_label = stims{i}{2};
    
    % prep the filter information
    params = prep_filt(params);
    
    % prep output directories
    params = prep_out(params, mainDir, [stims{i}{2} '/'], ...
        '', genImages);
    
      
    if(~exist([params.out.mainDir params.out.patternDir], 'dir'))
        mkdir([params.out.mainDir params.out.patternDir]);
    end
    
    % view the test pattern and save it into the test pattern folder
    generate_image(params.img.img, params.img.stim_label, 'testpattern.png', ...
        [params.out.mainDir params.out.patternDir], 'gray');
    
    % create the key/value pair mapping to hold model test patch diff
    % results for this stimulus
    stim_results = containers.Map();

    
    [params, filter_response] = BM_filter(params);


    for j = 1 : length(norm_settings)
        %reweight = BM_find_reweight(norm_settings{j});
        reweight = [1 1 1 1 1 1 1];
        %        reweight = [ 1.2041       1.1235       1.0482      0.97802      0.91253      0.85142       0.7944] ;

        % prep the normalization information
        tmp = norm_settings{j};
        params = prep_norm(params, tmp{1:4});

        % prep output directories
        params = prep_out(params, mainDir, [params.img.stim_label, '/'], ...
            [tmp{end}, '/'], genImages);
        
        % create the output directory for this model
        if(~exist([params.out.mainDir params.out.patternDir params.out.modelDir], 'dir'))
            mkdir([params.out.mainDir params.out.patternDir params.out.modelDir]);
        end
        
        % save the model's "friendly" name
        params.filt.label = tmp{end};
        
        % keep track of how far we've gone in mult-run
        fprintf(1, '\nTrial %i of %i: %s, %s\n', (i-1) * length(norm_settings) + j, ...
            length(stims) * length(norm_settings), params.img.stim_label, params.norm.settings);
        
        % add noise to the images
        %params.img.img = single(params.img.img) + 2 * [tmprand fliplr(tmprand)];
        %params.img.img = params.img.img ./ max(params.img.img(:)); 
        
        %params.filt.centerW = 1.5;
        
        
        % TODO: make sure none of the following makes any changes to
        % filter_response.  If they do, we need to make a backup and
        % restore it before running the next one
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2
        % run the model SELECT ONE OF THE FOLLOWING:
        if strcmp(params.norm.type, 'flodog')
            params.norm.sdmix = tmp{5};
            [params] = BM_odog_lodog_flodog(filter_response, params);
        elseif strcmp(params.norm.type, 'flodog2b')
            params.norm.sdmix = tmp{5};
            [params] = BM_odog_lodog_flodog(filter_response, params);
       elseif strcmp(params.norm.type, 'odog')
            [params] = BM_odog_lodog_flodog(filter_response, params);
        elseif strcmp(params.norm.type, 'lodog')
            [params] = BM_odog_lodog_flodog(filter_response, params);
        elseif strcmp(params.norm.type, 'unodog')
            [params] = BM_wn_unodog(filter_response, params);
        end
            

        % compute the average over the regions of interest
        params = BM_proc_regions(params);

        %   calc_resp_energy;

        % plot slice graphs
        % close all % need to remove figures so that figure handles match up correctly.
       BM_plot(params);
       params = summarize_params(params);
              
       
       % save the params info in an appropriately named file
       filename =  [params.out.mainDir params.out.patternDir params.out.modelDir ...
           params.img.stim_label '-' params.filt.label '.mat'];
       
       % save the file
       save(filename, 'params');
        
        % save diff results in struct for plotting comparisons
        stim_results(params.filt.label) = params.out.regions.diff;
        diff_results(params.img.stim_label) = stim_results;
    end

end

save([params.out.mainDir, 'results.mat'], 'diff_results');
jacob_plot_diffs_fullspread(diff_results, params);
jacob_plot_model_success(diff_results, params);
toc

diary off

disp(['Output found in ', mainDir])
% show interesting details about run.

%  wshow(combine(xoom(unshrink(filter_responsed.norm_mask)))), title('norm mask');
 % figure, wshow(combine(xoom(unshrink(filter_responsed.divided)))), title('normed resp');
