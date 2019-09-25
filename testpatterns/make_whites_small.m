% half sized version of thick lined whites (1 degree by 2 degree instead of
% 2 degree by 4 degree test patches used in bm 1999).
%
% Revision History:
% 11/08/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 5/19/14 -- (EM) changed size to be in degrees rather than pixels, made
%            output always a struct (unpadded model is in model.unpadded)

function model = make_whites_small(params, size_in_degrees)

if (nargin < 2)
    size_in_degrees = 1; % bm value 
end

size = size_in_degrees * params.const.PIXELS_PER_DEG;

model = whites_parametric(8, 6, 2, 3, size, 0, params);
model.region.hi = 2;
model.region.lo = 3;
model.region.bg = 1;

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;


end
