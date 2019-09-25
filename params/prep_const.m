% prep params.const
%
% Paul Hammon
% 7/12/05
%
% (optional) DEG_PER_PIXEL -- number of degrees of visual angle per pixel
% (optional) STD_TO_SPACE_CONST -- conversion factor
% (optional) SPACE_CONST_TO_WIDTH -- conversion factor
% (optional) ADD_CONST -- additive constant to prevent divide by zero
%
% function params = prep_const(params, DEG_PER_PIXEL, SPACE_CONST_TO_STD, SPACE_CONST_TO_WIDTH)function params = prep_const(params, DEG_PER_PIXEL, STD_TO_SPACE_CONST, SPACE_CONST_TO_WIDTH)
function params = prep_const(params, DEG_PER_PIXEL, SPACE_CONST_TO_STD, SPACE_CONST_TO_WIDTH, ADD_CONST)

% set params if specified, otherwise leave as default
if(nargin == 5)
    params.const.DEG_PER_PIXEL = DEG_PER_PIXEL;
    params.const.SPACE_CONST_TO_STD = SPACE_CONST_TO_STD;
    params.const.SPACE_CONST_TO_WIDTH = SPACE_CONST_TO_WIDTH;
    params.const.PIXELS_PER_DEG = double(int32(1/DEG_PER_PIXEL));
    params.const.ADD_CONST = ADD_CONST;
end

% update history
params.history{length(params.history) + 1} = 'prep_const';

