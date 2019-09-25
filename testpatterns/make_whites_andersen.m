
% BM paper 2004, Anderson stimulus on Fig. 1f, page 2
% test patch is 1 x 3 degrees
% for Howe stimulus Fig. 1c, use lg_position=1, rg_position=3;
% for Anderson stimulus, use lg_position=1.5, rg_position=2.5;

function model = make_whites_andersen(params)

block = ones(768,1024)*0.5; % make a gray background that is 1024x1024
block(144:144+480, 256:256+512)=1; % make a white background that is 384x512
patch_h=96;
patch_w=32;
str_pt_x=256;
str_pt_y=144;
% for Anderson stimulus
lg_position=1.5;
rg_position=2.5;

% % for Howe stimulus
% lg_position=1;
% rg_position=3;

%draw 1st, 3rd, 5th row of alternating black and white stripes 
for n=0:7
    block(144:144+patch_h, 256+32*n*2:256+32*n*2+32)=0; % 1st row 
    block(144+patch_h*2:144+patch_h*3, 256+32*n*2:256+32*n*2+32)=0; % 3rd row
    block(144+patch_h*4:144+patch_h*5, 256+32*n*2:256+32*n*2+32)=0; % 5th row
end 

% draw 2nd row all black except 5th patch
for n=0:15
    block(144+patch_h*1:144+patch_h*2, 256+32*n:256+32*n+32)=0;
end

% draw 6th patch all white for all 5 rows
block(144:144+patch_h*5, 256+32*5:256+32*5+32)=1;

% draw 11th patch all black for all 5 rows
block(144:144+patch_h*5, 256+32*10:256+32*10+32)=0;


% draw left gray patch
block(144+patch_h*lg_position:144+patch_h*(lg_position+1), 256+32*5:256+32*5+32)=0.5;

% draw right gray patch
block(144+patch_h*rg_position:144+patch_h*(rg_position+1), 256+32*10:256+32*10+32)=0.5;

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
       
    % cuts for graphing
    model.cuty = 470;  % horizontal cut
    model.cutx = 430;  % veritcal cut
    
    % human illusion (whites) direction for regions
    model.region.bg = 1;
    model.region.lo = 2;
    model.region.hi = 3;
    
    
model.size.h = params.img.size.h;
model.size.w = params.img.size.w;

    end