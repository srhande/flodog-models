% make a checkerboard with check size 5
% Paul Hammon
% 10/28/05

%12-4-07 % actual paper cpd 3.23

% model = make_check_4(param)
function model = make_check_5(params)

m = 200;
n = 768;
sq = 5;

% location of test patch
space_m = 0;
space_n = 350; 
target_test_m = 100; % 
target_test_n = (768 / 2) - (space_n / 2); % 192; % BM use 192


model = make_check_parametric(params, m, n, sq, target_test_m, target_test_n, space_m, space_n);

% location of test patch
space_m = 0;
space_n = 128; % 384; % BM use 384
target_test_m = 192; % BM use 192
target_test_n = (768 / 2) - (space_n / 2); % 192; % BM use 192

if(isstruct(model))
    % according to BM
    model.region.bg = 1;
    model.region.lo = 2;
    model.region.hi = 3;
    
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;

end
