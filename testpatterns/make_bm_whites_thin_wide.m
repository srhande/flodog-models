%same as thin lined whites (1 degree by 2 degree test patches) used in bm
%1999 (see page 4377)
%
% Revision History:
% 10/20/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 7-1-05 == added region types 

function model = make_bm_whites_thin_wide(params)

model = whites_parametric(16, 12, 2, 4, 32, 1, params);
model.region.hi = 2;
model.region.lo = 3;
model.region.bg = 1;

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;
