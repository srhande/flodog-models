% erode makes significant difference

function model = make_benary_cross(params)



block = ones(1024,1024); % make a white background that is 1024x1024

%draw the top and bottom gray rectangles
block(1:310, 1:1024)=0.5; %top gray rectangle
block(714:1024, 1:1024)=0.5; %bottom gray rectangle

%draw side gray rectangles
block(310:714, 1:20) = 0.5;
block(310:714, end-20:end) = 0.5;

%draw the black cross
block(310:714, 450:574)=0; %vertical component
block(450:574, 140:884)=0; %horizontal component

%draw right triangle (legs= 70 pixels)
for n=0:68
    block(380+n:380+n+1, 575:575+n)=0.5;
end

%draw left triangle {legs=70 pixels)
for n=0:48
    block(450+n:450+n+1, 351+n:449-n)=0.5;
end

model=block; 


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
    
    % manually fix some labeling issues
    model.labeled_regions(find(model.labeled_regions > 3)) = 1;
        
    % cuts for graphing
    model.cuty = 420;  % horizontal cut
    model.cutx = 600;  % veritcal cut
    
    % human illusion direction for regions
    model.region.bg = 1;
    model.region.hi = 3;
    model.region.lo = 2;
        
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;

    end