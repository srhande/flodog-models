% make a checkerboard with check size 32
% Paul Hammon
% 10/28/05
%
% model = make_check_32(param)
function model = make_check_30(params)

m = 210;
n = 768;
sq = 30;

space_m = 0;
space_n = 12 * 30 ; 
target_test_m = 100; % 
target_test_n = (768 / 2) - (space_n / 2); % 192; % BM use 192

model = make_check_parametric(params, m, n, sq, target_test_m, target_test_n, space_m, space_n);

if(isstruct(model))
    % according to BM
    model.region.bg = 1;
    model.region.hi = 2;
    model.region.lo = 3;
        
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;

end