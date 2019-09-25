function model = loadImage(params, filename, steps, paramsEqualsYes)

if (nargin < 3)
    steps = 2;
end
im = double(imread(filename));

if length(size(im)) == 2
    im_av = im;
else
    im_av = im(:,:,1) + im(:,:,2) +  im(:,:,3);
end

im_norm = im_av - min(min(im_av));
im_norm = im_norm ./ max(max(im_norm));

model = round(im_norm * steps) / steps; %forces values to 0, 1.0, or 0.5 for 2 steps



if (nargin == 4)
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
    
    if paramsEqualsYes > 0
        % Find and label all the regions which are set to grey level in the
        % image (0.5)
        value = 0.5;
        model.labeled_regions = label_regions(model.img, value);
    else
        model.labeled_regions = model.img > 0;
    end
    
    % cuts for graphing
    model.cuty = 553;  % horizontal cut
    model.cutx = 314;  % veritcal cut
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;
end