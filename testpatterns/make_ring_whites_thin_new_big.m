% a modified ring whites style stimulus
% same size as make_bm_whites_thin_wide 64 x 32 (2deg by 1deg)
% Paul Hammon
% 3/2/06
% 
% published name radial_whites_thin_new_big
%
% size: (optional) size in pixels
% patchHeight: (optional) height of test patch in degrees
% patchWidth: (optional) width of test patch in degrees
%
% function model = make_ring_whites_thin_new(param, size, patchHeight, patchWidth)
function model = make_ring_whites_thin_new_big(params, Size, patchHeight, patchWidth)

if nargin < 4
    patchHeight = 2;
    patchWidth = 1;
end

if nargin < 2
    Size = 768;
end

d = Size; %change here to change overall size
r = d /2;
model(1 : d, 1 : d)=0;
midpt=r;
rad=midpt;
radsq=midpt^2;

% set up
num_wedge = 42;
bw_wedge = 360/(num_wedge/2);
single_wedge = 360/num_wedge;

% here we want 64 x 32 (2deg by 1deg -- make_bm_whites_thin_wide)
patch_width = params.const.PIXELS_PER_DEG * patchWidth;
patch_height = params.const.PIXELS_PER_DEG * patchHeight;

% (1/num_wedge)*2*pi*r*mid_point = patch_width
mid_point = (patch_width * num_wedge) / (2*pi*r);
height_rad_fract = patch_height / r;

in_rad_sq=((mid_point - height_rad_fract/2) * rad)^2;
out_rad_sq=((mid_point + height_rad_fract/2) * rad)^2;

for i=1:d
    for j=1:d
        rvalsq=(i-midpt)^2 + (j-midpt)^2;
        if (rvalsq <= radsq)
            angle=atan2(i-midpt,j-midpt)*180/pi + 180; % adjust for 0 to 360
            if (mod(angle, bw_wedge) < single_wedge) % (mod(angle,30)<15)
                model(i,j)=1;
            end

            if((rvalsq < out_rad_sq) && (rvalsq > in_rad_sq))  %%never evals to true?
                if((angle >= 270 - single_wedge/2) && (angle <= 270 + single_wedge/2) || ((angle >= 90 - single_wedge/2) && (angle <= 90 + single_wedge/2)))
                    model(i,j)=.5;
                end
            end

        else
            model(i, j) = 0.5;
        end
    end
end

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
    
    % for some reason this has some trouble -- manually fix
    model.labeled_regions(find(model.labeled_regions == 4)) = 3;
        
    % cuts for graphing
    model.cuty = 320;  % horizontal cut
    model.cutx = 512;  % veritcal cut
    
    % human illusion direction for regions
    model.region.bg = 1;
    model.region.hi = 3;
    model.region.lo = 2;
    
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;


end