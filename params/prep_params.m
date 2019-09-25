% create a params struct for BM stuff
%
% Paul Hammon
% 7/12/05
%
% Revision History:
% 5/17/14 -- (EM) added output directory and log file fields to out struct
% 5/24/14 -- (EM) added size.h and size.w fields to img struct for central
%            tracking of overall image size after padding


function params = prep_params()

% some constants
const = struct;
const.DEG_PER_PIXEL = 0.03125;                                  % number of degrees of visual angle per pixel
const.SPACE_CONST_TO_STD = 1 / sqrt(2);                         % conversion factor
const.SPACE_CONST_TO_WIDTH = 2 * sqrt(log(2));                  % conversion factor
const.PIXELS_PER_DEG = double(int32(1/const.DEG_PER_PIXEL));    % number of pixels per degree of visual angle (automatically calculated from DEG_PER_PIXEL
const.ADD_CONST = 10^(-12);                                     % additive constant for preventing divide by zero

% normalization information
norm = struct;
norm.type = [];             % normalization type can be {'freq', 'local_o', 'global_o'}
norm.sig1fun = [];          % create an inline function for setting the extent 
                            % of the normaliztion in the direction of the filter
                            % can take frequency information (f) or
                            % orientation (o)
norm.sr = [];               % extent perpendicular to filter (as a multiple of sig1fun)
norm.x = 1024;              % extent of normalization mask in x
norm.y = 1024;              % extent of normalization mask in y
norm.fft_adjust = 10^(-6);  % fix for FFT inaccuracies
norm.settings = [];         % summary of setting for file names, etc.
norm.sdmix = [];            % sdmix setting for FLODOG model

% filter information (see calculated values below)
filt = struct;
filt.norm = 0;                  % whether or not to use normalized filters
filt.orientations = 0:30:179;   % set of orientation angles, in degrees (6 steps of 30 degrees by default)
filt.freqs = 0 : 1 : 6;         % set of different "mechanisms" (7 by default)
filt.stdev_pixels = [];         % standard deviation of different freqency filters in pixels
filt.w.use = 1;                 % whether or not to use filter weighting
filt.w.val = [];                % array of weight values per frequency
filt.w.valslope = 0.1;          % slope of weighting function
filt.x = 1024;                  % extent of filter in x
filt.y = 1024;                  % extent of filter in y
filt.label = [];                % holds file and directory friendly name of filter normalization model
% following values are only used in bm_filt, not bm_filt_fast
filt.stretchWidth = 1;          % width of DOG, == 1 in ODOG, > 1 makes filter more GABOR-like.
filt.negwidth = 1;              % std ratio of negative surround to center, == 1 in ODOG
filt.neglen = 2;                % std ratio of negative surround to center, == 2 in ODOG
filt.centerW = 1;               % weight on center guassian, >1 = positive sum guassian. == 1 in ODOG


% image information
img = struct;
img.img = [];               % input image to process
img.stim = [];              % name of make_ file to get stimulus from
img.stim_label = [];        % directory and file friendly name of stim
img.cutx = [];              % location of vertical cut in pixels for BM_plot
img.cuty = [];              % location of horizontal cut in pixels for BM_plot
img.labeled_regions = [];   % integer labels of the different regions of interest
img.region.bg = [];         % label of background for this stimuli
img.region.hi = [];         % label(s) of regions which are supposed to be perceptually brighter
img.region.lo = [];         % label(s) of regions which are supposed to be perceptually darker
img.size.h = 1024;          % height of image in pixels (after padding) - note this is overwritten during pattern generation unless restored
img.size.w = 1024;          % width of image in pixels (after padding) - note this is overwritten during pattern generation unless restored

% model output information
out = struct;
out.img = [];                   % output of the model
out.regions.mean = [];          % array of mean values of the different regions
out.regions.stdev = [];         % array of stdev values of the different regions
out.regions.min = [];           % array of min values of the different regions
out.regions.max = [];           % array of max values of the different regions
out.regions.diff = [];          % array of differences of means between hi and lo regions - assumes hi and lo region means are arrayed in order (first hi mean minus first lo mean, etc)
out.mainDir = ['./output/'];   	% directory under which all output is stored for this run of the model
out.patternDir = ['pattern1/'];	% subdirectory for the current test pattern's files under main directory
out.modelDir = ['model1/'];   	% subdirectory for the current model under the test pattern's directory
out.logFile = [];               % log file name - this should contain details of the model's and test pattern's params
out.genImages = 1;              % boolean for whether images for each model component should be generated: 1 for yes
out.figTitle = '';              % experiment name - used as figure title for final figures


% put everything into the params struct
params = struct('const', const, 'norm', norm, 'filt', filt, 'img', img, 'out', out);


% calculate values for filt struct
% compute the standard deviations of the different Gaussian in pixels
space_const = 2.^filt.freqs * 1.5; % space constant of Gaussians
stdev_pixels = space_const .* const.SPACE_CONST_TO_STD; % in pixels

% matches Table 1 in BM(1999)
space_const_deg = space_const * const.DEG_PER_PIXEL; % in deg.

% (almost matches) points along x-axis of Fig. 10 BM(1997)
cpd = 1 ./ (2 * space_const_deg * const.SPACE_CONST_TO_WIDTH);

% (almost matches) points along y-axis of Fig. 10 BM(1997)
w_val = cpd .^ filt.w.valslope;

% place everything into the struct
params.filt.stdev_pixels = stdev_pixels;
params.filt.w.val = w_val;


% put in a history field in case it becomes useful later
params.history = {'prep_params'};