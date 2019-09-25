% make small grating induction stimulus (1999 bm, page ?)
%
% Revision History:
% 11/08/04 -- takes a parameter, model, which if present sets up a
% structure for use in other BM processing code.  Set up code to process
% the pertinent parameters.
% 1/14/04 -- modified to use label_regions 
% 7-1-05 == added human illusion direction for regions (only for 3 regions,
% labled by hand quick and dirty).
function model = make_small_grating_induction(params)

for (i = 1:384)
    model(i,1:512) = .5 + sin(4*2*pi*[0:(1/511):1])/2;
end

model(176:176+32, 1:512) = .5;

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
    
    % hand code some values, rather arbitrary.
    model.labeled_regions(1:318, 1:1023) = 2;
    model.labeled_regions( 499:525,455:505) = 3;
    model.labeled_regions( 499:525,520:570) = 4;
    
    % cuts for graphing
    model.cuty = 512;  % horizontal cut
    model.cutx = 512;  % veritcal cut
    
    % human illusion direction for regions
    model.region.bg = 2;
    model.region.hi = 3;
    model.region.lo = 4;   
    
    
model.size.h = params.img.size.h;
model.size.w = params.img.size.w;


end