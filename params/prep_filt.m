% prep params.filt
%
% Paul Hammon
% 7/12/05
%
% (optional) w_use -- whether or not to use the BM weighting
% (optional) norm_filt -- whether or not to use normalized filters
% (optional) w_val -- the slope of the weighting function
% (optional) orientations -- set of orientation angles, in degrees
% (optional) freqs -- set of different "mechanisms"
% (optional) x -- extent of filter in x direction
% (optional) y -- extent of filter in y direction
%
% function params = prep_filt(params, norm_filt, w_use, w_val_slope, orientations, freqs, x, y)
function params = prep_filt(params, norm_filt, w_use, w_val_slope, orientations, freqs, x, y)

% update history
params.history{length(params.history) + 1} = 'prep_filt';

% set the default parameters
if(nargin == 8)
    % compute the standard deviations of the different Gaussian in pixels
    space_const = 2.^freqs * 1.5; % space constant of Gaussians
    stdev_pixels = space_const .* params.const.SPACE_CONST_TO_STD; % in pixels
    
    % matches Table 1 in BM(1999)
    space_const_deg = space_const * params.const.DEG_PER_PIXEL; % in deg.
    
    % (almost matches) points along x-axis of Fig. 10 BM(1997)
    cpd = 1 ./ (2 * space_const_deg * params.const.SPACE_CONST_TO_WIDTH);
    
    % (almost matches) points along y-axis of Fig. 10 BM(1997)
    w_val = cpd .^ w_val_slope;
    
    % place everything into the struct
    params.filt.norm = norm_filt;               % whether or not to normalize the filters
    params.filt.orientations = orientations;    % set of orientation angles, in degrees
    params.filt.freqs = freqs;                  % set of different "mechanisms"
    params.filt.stdev_pixels = stdev_pixels;    % standard deviation of different freqency filters in pixels
    params.filt.w.use = w_use;                  % whether or not to use filter weighting
    params.filt.w.val = w_val;                  % array of weight values
    params.filt.w.valslope = w_val_slope;       % slope of weighting function
    params.filt.x = x;                          % extent of filter in x direction
    params.filt.y = y;                          % extent of filter in y direction
end