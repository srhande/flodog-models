% make bullseye display (Fig. 3G in article "Brightness assimilation in
% bullseye displays," pp 311, 2004)
%
% Revision History:
% 1/18/05 --

% 6-21-06 == updated to match p 317, fig 5a.

function model = make_bullseye_rect_thin(params)

block = ones(384,1024)*0.5; % make a gray background that is 384 by 1024
half1_block= ones(384, 512)*0.5;

numbands=4; % number of surrounding bands
target_size_d= [0.608,0.608]; % target square has a width of 0.608 degrees (pp 312)
band_size_d= [0.122, 0.122]; % width of band is thick, 20% of the target size length (pp 312)
target_size_p= floor (target_size_d * 32); % convert target size in degrees to pixels
band_size_p= floor (band_size_d * 32); % convert band size in degrees to pixels


half1_block=draw(numbands, target_size_p, band_size_p);
block= [half1_block 1- half1_block];
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
    model.cuty = 512;  % horizontal cut
    model.cutx = 256;  % veritcal cut

    % define regions
    model.region.hi = 2;
    model.region.lo = 3;
    model.region.bg = 1;

model.size.h = params.img.size.h;
model.size.w = params.img.size.w;


end


function half_block = draw(numbands, target_size_p, band_size_p)

half_block= ones(384, 512)*0.5; % create a gray background block (384 by 512)
total_size= [ floor(target_size_p(1)+ band_size_p(1)*numbands*2), floor(target_size_p(2)+band_size_p(2)*numbands*2)]; % calculate the total size of the stimuli block [length, width]
lc_coord= [ floor((384-total_size(1))/2), floor((512-total_size(2))/2)];% find the coordinates of the left corner the stimuli block
for n=0:numbands
    if n==numbands
        half_block( lc_coord(1):(lc_coord(1)+ total_size(1)), lc_coord(2):(lc_coord(2)+total_size(2)))= 0.5;
        break
    elseif (n/2- floor (n/2)==0)
        half_block( lc_coord(1):(lc_coord(1)+ total_size(1)), lc_coord(2):(lc_coord(2)+total_size(2)))= 0;
    else
        half_block( lc_coord(1):lc_coord(1)+ total_size(1), lc_coord(2):lc_coord(2)+total_size(2))= 1;
    end

    lc_coord= [ floor(lc_coord(1)+band_size_p(1)), floor(lc_coord(2)+band_size_p(2))];
    total_size=[ floor(total_size(1)-2*band_size_p(1)), floor(total_size(2)-2*band_size_p(2))];
    n=n+1;
end



