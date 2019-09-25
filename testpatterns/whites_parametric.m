%whites_parametric_patch(width,height,patchy, patch_inlay, scale, leftmost_color)
%Return dual-patch whites stimuli, as floats scaled 0-1.
%think of width and height as counts of square blocks of the patch in x,y
%width = number of bars
%height * scale = height of bars in pixels, width/height = aspect ratio
%patchy = size of patch (* scale = in pixels) 
%patch_inlay = number of bars from outside edges inward that gray is placed
%scale = how big each square block is (min = 3)
%bg color = color of leftmost bar
%
% Revision History:
% 10/20/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 1/14/04 -- modified to use label_regions
% 5/19/14 -- (EM) adjusted to always create struct for model - original
%            unstructured output is now saved within the struct as model.unpadded
function model = whites_parametric(width,height,patchy, patch_inlay, scale, leftmost_color, params)

patchy = patchy/2;
inverted = leftmost_color;
patch = .5;

for (i = 1:width*scale)
    model(1:height*scale,i) = mod(floor((i-1)/scale),2);
end

if (inverted) % invert bg
    model = 1 - model;
end

model(((height/2) * scale)-patchy*scale:((height/2) * scale)+patchy*scale, ...
    1+(patch_inlay-1)*scale:(patch_inlay)*scale) = patch;

patch_inlay_2 = width-patch_inlay;

model(((height/2) * scale)-patchy*scale:((height/2) * scale)+patchy*scale, ...
    1+patch_inlay_2*scale:(patch_inlay_2+1)*scale) = patch;

[y x] = size(model);

% create a structure for use with other BM code
    
% use the variable img for the image and model for the stuct
img = model;
clear model;

% set image parameters including details that will be useful for plotting
model = struct;

% store a copy of the unpadded image
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

% for plotting, cut with a line along row ycut
% and cut along column xcut
% find the bounding coordinates of the regions first
x_pad_shift = (512 - x/2);
x1 = 1+(patch_inlay-1)*scale + x_pad_shift;
x2 = (patch_inlay)*scale + x_pad_shift;

y_pad_shift = (512 - y/2);
y1 = ((height/2) * scale)-patchy*scale + y_pad_shift;
y2 = ((height/2) * scale)+patchy*scale + y_pad_shift;
x_pad_shift = (512 - x/2);

% cuts for graphing
model.cuty = round((y1 + y2)/2);  % horizontal cut
model.cutx = round((x1 + x2)/2);  % veritcal cut

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;

end
