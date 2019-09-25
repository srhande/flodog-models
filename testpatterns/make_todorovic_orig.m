% make Todorovic effect: BM '99, page 4373-4374
% types: 'equal', 'in-large', 'in-small', 'out'
%
% Revision History:
% 01/28/05--
% 7-1-05 == added human illusion direction for regions.
% Not sure what correct answer is here, so I used the psychophysics from BM 99
% 5-30-14 == (EM) generalized function to work for all types of todorovic
%            illusion

function model = make_todorovic(params, type)

patch_degrees = 3; %each of the four squares is 3 degrees
p = patch_degrees*32; %convert patch size from degrees to pixels

block_height = 384;
block_width = 512;
block = ones(block_height, block_width);

%make gray cross (change cross length to get different conditions)

%cross length= 96 exactly on Fig. 9b (BM '99, page 4373)
%cross length=170 approx. on Fig. 9c (BM '99, page 4373)
%cross length= 240 exactly on Fig. 9d (BM '99, page 4374)
%cross length= 280 approx. on Fig. 9e (BM '99, page 4374)

if strcmp(type, 'equal')
    cross_length= 240;
    %make vertical cross
    block( (192-(cross_length)/2): ((192-(cross_length)/2)+ cross_length), 232:280)=0.5;
    %make horizontal cross
    block( 168:216, (256-(cross_length)/2): (256-(cross_length)/2 + cross_length))= 0.5;
elseif strcmp(type, 'in-large')
    cross_length= 170;
    %make vertical cross
    block( (192-(cross_length)/2): ((192-(cross_length)/2)+ cross_length), 232:280)=0.5;
    %make horizontal cross
    block( 168:216, (256-(cross_length)/2): (256-(cross_length)/2 + cross_length))= 0.5;
elseif strcmp(type, 'in-small')
    cross_length= 96;
    %make vertical cross
    block( (192-(cross_length)/2): ((192-(cross_length)/2)+ cross_length), 232:280)=0.5;
    %make horizontal cross
    block( 168:216, (256-(cross_length)/2): (256-(cross_length)/2 + cross_length))= 0.5;
elseif strcmp(type, 'out')
    cross_length= 280;
    %make vertical cross
    block( (192-(cross_length)/2): ((192-(cross_length)/2)+ cross_length), 233:279)=0.5;
    %make horizontal cross
    block( 169:215, (256-(cross_length)/2): (256-(cross_length)/2 + cross_length))= 0.5;
end

%make the four squares
block(72:168, 136:232)=0; %make upper left hand corner square
block(216:312, 136:232)=0; %make lower left hand corner square
block(72:168, 280:376)=0; %make upper right hand corner square
block(216: 312, 280:376)=0; %make lower right hand corner square

%make the opposite
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
    model.cutx = 256;  % veritcal cut
    
    % human illusion direction for regions
    model.region.bg = 1;
    model.region.hi = 2;
    model.region.lo = 3;
    
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;
end