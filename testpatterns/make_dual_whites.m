% Alan's stimulus of two make_white_small images, one rotated by 90 degrees
%
% Revision History:
% 11/08/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 1/14/05 -- fixed the region defining part
% 7-1-05 == added human illusion direction for regions
% 5/27/14 -- (EM) updated labels for hi and lo regions to show all four

function model = make_dual_whites(params)

model = ones(384,768)*.5;

whites_model = make_whites_small(params);

whites_model = whites_model.unpadded;

model = insert_at(whites_model, model, 384/2, 128 + 64);

model = insert_at(whites_model', model, 384/2, 768 - 128 - 64);

% create a structure for use with other
% BM code
    
% use the variable img for the image and model for the stuct
img = model;
clear model;

% set image parameters including details that will be useful for plotting
model = struct;

% save copy of unpadded model
model.unpadded = img;

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

% Find and label all the regions which are set to grey level in the
% image (0.5)
value = 0.5;
model.labeled_regions = label_regions(model.img, value);

% cuts for graphing
model.cuty = 512;  % horizontal cut
model.cutx = 704;  % veritcal cut

% human illusion direction for regions
model.region.bg = 1;
model.region.hi = [2, 3];
model.region.lo = [4, 5];

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;

end

% helper function to position the make_whites_small images
function dest = insert_at(src, dest, y, x)
[cy cx] = size(src);
cy = cy/2;
cx = cx/2;
dest(y-cy:y+cy -1, x-cx:x+cx-1 ) = src;
end
