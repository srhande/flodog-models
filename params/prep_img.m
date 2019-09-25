% prep params.img
%
% Paul Hammon
% 7/12/05
%
% stim -- name of make_ file to get stimulus from
%
% function params = prep_img(params, stim)
% 7-13-05 == added option where stim can be a string that evaluates to a
% function call, in which case stim is eval'ed not feval'ed.
% 5-24-14 == (EM) added parameters for height and width to track the total size
%            of the image after padding

function params = prep_img(params, stim, h, w)

% update params if size is specified, otherwise use default
if nargin == 4
    params.img.size.h = h;
    params.img.size.w = w;
end

% update history
params.history{length(params.history) + 1} = 'prep_img';

if (any(stim == '(')) % test for make_ file with additional paramaters passed from bm_multi_run
    params.img = eval(stim);
else % no list of paramaters, so call the make_* file, 
     % and pass a dummy arg to indicate we want the params form.
    params.img = feval(stim, 1);
end

% this is now done within model generation functions
% % use actual image size instead of default size if image is bigger than
% % default
% [imgH, imgW] = size(params.img);
% if imgH > params.img.size.h
%     params.img.size.h = imgH;
% end
% if imgW > params.img.size.w
%     params.img.size.w = imgW;
% end


% add in remaining stimulus info
params.img.stim = stim;

