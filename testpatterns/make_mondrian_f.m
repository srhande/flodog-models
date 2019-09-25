%Mondrian Stimulus F from BM 2001, pg. 2489
% function draw_square(str_pt_x, str_pt_y, brightness)
% function draw_para_gram(para_gram_kind, str_pt_x, str_pt_y, brightness)

% published mondrian


function model = make_mondrian_f(params)

block =ones(1024,1024)*0.5; % make a gray background that is 1024x1024
str_pt_x=352; %x coordinate of upper left corner starting point
str_pt_y=352; %y coordinate of upper left corner starting point
brightness=0; 
counter_x=0; 
counter_y=65; 
i=0; 

%Stimuli F
for n=0:4
    
    i=0; %row 1, 5 squares
    if mod(n,2)==0
        brightness=0.76;
    else
        brightness=0.48;
    end
    block=block+draw_square( str_pt_x+counter_x,str_pt_y+counter_y*i,brightness);
    
    i=1; %row 2, 5 parallelgram, kind 1
    if n==2
        brightness=0.5;
    else if mod(n,2)==0
            brightness=1.00;
        else
            brightness=0.81;
     end
    end
    block=block+draw_para_gram(1, str_pt_x+counter_x, str_pt_y+counter_y*i, brightness);
    
    i=2; %row 3, 5 squares
    if mod(n,2)==0
        brightness=0.76;
    else
        brightness=0.48;
    end
    block=block+draw_square(str_pt_x+counter_x-31, str_pt_y+counter_y*i-1, brightness);
    
    i=3; %row 4, 5 parallelgram, kind 2
    if n==2
        brightness=0.5;
    else if mod(n,2)==0
            brightness=0.53;
        else
            brightness=0.00;
        end
    end
    block=block+draw_para_gram(2, str_pt_x+counter_x-31, str_pt_y+counter_y*i-1, brightness);
    
    i=4; %row 5, 5 squares
    if mod(n,2)==0
        brightness=0.76;
    else
        brightness=0.48;
    end
    block=block+draw_square( str_pt_x+counter_x,str_pt_y+counter_y*i-2,brightness);
    
    counter_x=counter_x+65;
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
        
    % cuts for graphing
    model.cuty = 450;  % horizontal cut
    model.cutx = 500;  % veritcal cut
    
    % define regions
    model.region.hi = 3;
    model.region.lo = 2;
    model.region.bg = 1;
        
    model.size.h = params.img.size.h;
    model.size.w = params.img.size.w;


end           

%function for drawing square patches (64x64)
function square=draw_square(str_pt_x, str_pt_y, brightness) 
square= zeros(1024, 1024);
square(str_pt_y:str_pt_y+64, str_pt_x:str_pt_x+64)=brightness-0.5;


function para_gram=draw_para_gram(para_gram_kind, str_pt_x, str_pt_y, brightness)
increment=0;
step_div=2; %angle~=26 degrees
num_div=round(64/step_div);
para_gram=zeros(1024, 1024);
    if para_gram_kind==1
        for n=0:(num_div-1)
            for x=0:(step_div-1)
           para_gram(str_pt_y+increment+x:str_pt_y+increment+x, str_pt_x-n:str_pt_x+64-n)=brightness-0.5;
            end 
           increment=increment+step_div;
       end
    end
    increment=0;
    if para_gram_kind==2
        for n=0:(num_div-1)
            for x=0:(step_div-1)
           para_gram(str_pt_y+increment+x: str_pt_y+increment+x, str_pt_x+n:str_pt_x+64+n)=brightness-0.5;
            end
            increment=increment+step_div;
        end
    end
    
    
    