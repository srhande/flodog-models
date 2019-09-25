% make a checker board
% Paul Hammon
% 10/28/05
%
% param = pass a 1 to return a struct
% [m, n] = desired size of image
% sq = size of square
%
% function model = make_check_parametric(param, m, n, sq)
function model = make_check_parametric(params, m, n, sq, target_test_m, target_test_n, space_m, space_n)

% % board size
% m = 384;
% n = 768;
% 
% % check size
% sq = 4;

if(nargin < 5)
    % location of test patch
    space_m = 0;
    space_n = 384; % BM use 384
    target_test_m = 192; % BM use 192
    target_test_n = 192; % BM use 192
end

% figure out how many rows and columns of checks will fit
m_check = floor(m / sq);
n_check = floor(n / sq);

% draw one square
check = ones(sq, sq);

% color of top left check
first_check = 0;

% draw one column and then repeat it n_check times
this_check = first_check;
col = ones(m, sq) * 0.5;
for i = 1 : m_check

    % draw the check
    col((i - 1) * sq + 1 : i * sq, 1 : sq) = this_check;

    % switch the color
    this_check = 1 - this_check;

end

% loop over the columns and draw them in
board = [];
this_col = col;
for i = 1 : n_check

    % draw in the column
    board = [board,  this_col];

    % switch the color
    this_col = ones(size(this_col)) - this_col;
end

% now make the test patches

% draw the leftmost
test_m = floor(target_test_m / sq) * sq;
test_n = floor(target_test_n / sq) * sq;
color_left = board(test_m, test_n);

% want to always put it over a white square
% if it would have put it on a black square, move over 1
if(color_left == 0)
    test_n = test_n + sq;
end
board(test_m + 1 : test_m + sq, test_n + 1 : test_n + sq) = 0.5 * check;

% want to make the cut through this square
cuty = test_m + 1 + round(sq/2);
cutx = test_n + 1 + round(sq/2);

% draw the rightmost
test_m = floor((target_test_m + space_m)/ sq) * sq;
test_n = floor((target_test_n + space_n)/ sq) * sq;

% move if color is the same
color_right = board(test_m, test_n);

% if on same color as the left, move to center
if(color_left == color_right)
    test_n = test_n - sq;
end
board(test_m + 1 : test_m + sq, test_n + 1 : test_n + sq) = 0.5 * check;

model = board;

% % if the parameter param is passed, create a structure for use with other
% % BM code
% if(params == 1)
    
    % use the variable img for the image and model for the stuct
    img = board;
    clear board;

    % set image parameters including details that will be useful for plotting
    model = struct;
    
    % use actual image size instead of default size if image is bigger than
    % default
    [imgH, imgW] = size(img);
    if imgH > params.img.size.h
        params.img.size.h = imgH;
    end
    if imgW > params.img.size.w
        params.img.size.w = imgW;
    end
    
    
    % pad the image
    padded = model_pad_patch(img, params.img.size.h, params.img.size.w);

    % store the padded image in the struct
    model.img = padded;
    [y, x] = size(model.img);

    % Find and label all the regions which are set to grey level in the
    % image (0.5)
    value = 0.5;
    model.labeled_regions = label_regions(model.img, value);
            
    % cuts for graphing
    offset_m = round((y - m)/2);
    offset_n = round((x - n)/2);
    model.cuty = cuty + offset_m;  % horizontal cut
    model.cutx = cutx + offset_n;  % veritcal cut

% end
