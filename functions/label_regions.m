% Automatically mark regions whose pixels match a specified value.
% Assumes things are neighbors only if they have touching faces or
% corners (8 - neighborhoods).
%
% INPUT :   img - image to examine
%           value - pixel value to look for
% OUTPUT:   mask - image mask with regions marked by a region number
%
% Paul Hammon 1/12/04
function mask = label_regions(img, value)

region_number = 2;  % start at 2 since the mask begins as 0 or 1
missed = 0;         % flag to note that no pixels in the row have been missed

[row col] = size(img);
mask = double(img == value);

% loop through the image looking for the passed value
for i = 1 : row
    for j = 1 : col

        % if this region has not been set yet, grow the region and set it
        if(mask(i, j) == 1)

            % disp(['i = ' num2str(i) ' j = ' num2str(j)]);
            
            mask = grow_region(i, j, mask, region_number);
            region_number = region_number + 1;

        end
    end
end

% reduce things so they start at 1
mask(find(mask > 0)) = mask(find(mask > 0)) - 1;

%mask = uint16(mask);