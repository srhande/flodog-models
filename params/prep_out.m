% prep params.out
%
% Eric Morgan
% 5/17/14
%
% function params = prep_out(params)
function params = prep_out(params, mainDir, patternDir, modelDir, genImages, figTitle)

% if set params if specified, otherwise leave them as default
if(nargin > 4)
    params.out.mainDir = mainDir;          % directory under which all output is stored for this run of the model
    params.out.patternDir = patternDir;    % subdirectory for the current test pattern's files under main directory
    params.out.modelDir = modelDir;        % subdirectory for image files for the current model
    params.out.genImages = genImages;      % whether images should be created for each model component (1 = yes)
end

if(nargin == 6)
    params.out.figTitle = figTitle;         % experiment title used for figures
end

% update history
params.history{length(params.history) + 1} = 'prep_out';

% other parameters in the struct, for reference:
%params.out.img = [];                  % output of the model
%params.out.regions.mean = [];         % array of mean values of the different regions
%params.out.regions.stdev = [];        % array of stdev values of the different regions
%params.out.regions.min = [];          % array of min values of the different regions
%params.out.regions.max = [];          % array of max values of the different regions
%params.out.logFile = [];              % log file name - this should contain details of the model's and test pattern's params
