%same as thick lined whites (2 degree by 4 degree test patches) used in bm
%1999 (see page 4377, 4371)
%
% Revision History:
% 10/20/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 7-1-05 == added region types 
% 8-25-05 == added patch_pixel_offset

function model = make_bm_whites_thick(params, patch_pixel_offset)

eval('patch_pixel_offset;', ' patch_pixel_offset = 0;'); % default val for patch pixel offset
   
model = make_whites_parametric(8, 6, 2, 3, 64, 0, patch_pixel_offset, params);
model.region.hi = 2;
model.region.lo = 3;
model.region.bg = 1;

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;

