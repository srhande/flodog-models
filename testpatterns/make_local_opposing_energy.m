
% make a minimal White's effect with perpendicular energy located near the
% illusion patch. 
% Alan Robinson, 2-9-05
function model = make_local_opposing_energy(params)

% TODO: change this to use degrees for scaling?
scale = 64; % width of bars

img = round(rand(384,512)); 

middle = 128 + 64 + 16; % location of bar relative to 512-pixel-wide half of image

% img(:, middle+scale:middle+2*scale) = 0;
% img(:, middle-scale:middle) = 0;

% img(:,middle-1) = 0;
% img(:,middle+17) = 0;

img(:, middle:middle+scale) = 1;


img(384/2 - scale/2 :384/2 + scale/2, middle:middle+scale) = .5;

left = img;

for (i = 1:384)
    if (mod(i+scale/2,scale) > scale/2) 
    img(i,:) = 1;
    else
        img(i,:) = 0;
    end
end

% img(:, middle+scale:middle+2*scale) = 0;
% img(:, middle-scale:middle) = 0;

% img(:,middle-1) = 0;
% img(:,middle+17) = 0;

img(:, middle:middle+scale) = 1;


img(384/2 - scale/2 :384/2 + scale/2, middle:middle+scale) = .5;

model = [left img];

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
    model.cutx = 256;  % veritcal cut

end
