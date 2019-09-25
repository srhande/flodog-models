%regions for triangles 3 and 4 with diagonal cutlines

function model = make_todorovic_benary_cross_3_4_diag(params)

block = ones(1024,1024); % make a white background that is 1024x1024

%draw the top and bottom gray rectangles
block(1:310, 1:1024)=0.5; %top gray rectangle
block(714:1024, 1:1024)=0.5; %bottom gray rectangle

%draw the black L 
block(311:512, 1:100)=0; %top half
block(512:714, 1:924)=0; %bottom half

%draw triangles {left to right, legs=70 pixels, 4 triangles total)

%draw 1st triangle (left-most)
for n=0:68
    block(442+n:442+n+1, 101:101+n)=0.5;
end

%draw 2nd triangle
for n=0:48
    block(512+n:512+n+1, 333+n:432-n)=0.5;
end

%draw 3rd triangle
for n=0:48
    block(462+n:462+n+1, 642-n:642+n)=0.5;
end

%draw 4th triangle (right-most)
for n=0:68
    block(512+n:512+n+1, 854+n:924)=0.5;
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
    
    %cutline for 3rd triangle
    for n=0:48
        model.labeled_regions(462+n:462+n+1, 642:642)=4.5;
    end
    [i,j]=find(model.labeled_regions==3);
    n=size(i);
    for c=1:n
        model.labeled_regions(i(c),j(c))=0.0;
    end
    [i,j]= find((model.labeled_regions)==4.5);
    n=size(i);
    for c=1:n
        model.labeled_regions(i(c),j(c))=3.0;
    end
    
    %cutline for 4th triangle
    for n=0:34
        model.labeled_regions(512+n:512+n+1, 924-n-1:924-n)=2.5;
    end
    [i,j]=find(model.labeled_regions==5);
    n=size(i);
    for c=1:n
        model.labeled_regions(i(c),j(c))=0.0;
    end
    [i,j]= find((model.labeled_regions)==2.5);
    n=size(i);
    for c=1:n
        model.labeled_regions(i(c),j(c))=5.0;
    end
    
   
    

    % cuts for graphing
    model.cuty = 382;  % horizontal cut
    model.cutx = 487;  % veritcal cut
    
    % human illusion direction for regions
    model.region.bg = 1;
    model.region.hi = 5;
    model.region.lo = 3;
    
model.size.h = params.img.size.h;
model.size.w = params.img.size.w;


    end