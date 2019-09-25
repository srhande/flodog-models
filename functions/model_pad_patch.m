% Gery-pad and center an image to make it the proper size (1024 x 1024)
% Revision History:
% 10/21/04 -- made minor change from subtracting 1 at end to range to
% adding one at beginning of range -- fixes cases where would otherwise
% start at 0th index.
% 5-24-14 -- (EM) removed default parameter settings for h and w - these
%            are now required so that value from params.img.size can be used

function padded = model_pad_patch(model, h, w)

% if nargin < 3
%     h = 1024;
%     w = 1024;
% end

%insert model into the center of a 1024x1024 grey matrix
[y x] = size(model);
padded(1:h,1:w) = .5;
padded(((h/2)-y/2)+1 : ((h/2)+y/2), ((w/2)-x/2)+1 : ((w/2)+x/2)) = (model); 