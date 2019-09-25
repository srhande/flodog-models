% make SBC patches with 3 degree gray patchs (1999 bm, page 4368)
%
% Revision History:
% 10/20/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 1/13/04 -- updated to use label_regions to label the regions of interest 
% 7-1-05 == added human illusion direction for regions 
function model = make_sbc_large(params)

patch_degrees = 3;

block_height = 384;
block_width = 480;

block = ones(block_height, block_width);

[y x] = size(block);

p = patch_degrees*32/2;

block(y/2-p:y/2+p, x/2-p:x/2+p) = .5;
model = [block 1 - block];

% if the parameter param is passed, create a structure for use with other
% BM code
if(nargin > 0)
    
    % use the variable img for the image and model for the stuct
    img = model;
    clear model;

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

    % Find and label all the regions which are set to grey level in the
    % image (0.5)
    value = 0.5;
    model.labeled_regions = label_regions(model.img, value);
        
    % cuts for graphing
    model.cuty = 512;  % horizontal cut
    model.cutx = 272;  % veritcal cut

    % human illusion direction for regions
    model.region.bg = 1;
    model.region.hi = 3;
    model.region.lo = 2; 
    
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;

end