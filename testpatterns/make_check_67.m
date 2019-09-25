% make a checkerboard with check size 64
% Paul Hammon
% 10/28/05
%
% model = make_check_64(param)
function model = make_check_67(params)

m = 3 * 67;
n = 768-67;
sq = 67;

space_m = 0;
space_n = 67*5; 
target_test_m = m/2; % 
target_test_n = 67*2;


model = make_check_parametric(params, m, n, sq, target_test_m, target_test_n, space_m, space_n);


if(isstruct(model))
    % according to BM
    model.region.bg = 1;
    model.region.hi = 2;
    model.region.lo = 3;
        
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;

end

