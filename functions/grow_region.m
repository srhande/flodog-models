% Grow a region from the starting point (i, j) to include all touching
% pixels that share a face with the current pixel (4-neighbors).
%
% INPUT :   i_start - starting row
%           j_start - starting column
%           mask - mask to start with
%           reg_num - number to mark region with
% OUTPUT:   region_mask - mask with grown region marked with reg_num
%
% Paul Hammon 1/12/04
function region_mask = grow_region(i_start, j_start, mask, reg_num)

% get image size
[row col] = size(mask);

% value to set region finds to
set_val = -1;

% set the current pixel
mask(i_start, j_start) = set_val;

% loop through the image looking for any pixel attached to the passed value
for i = 1 : row
    for j = 1 : col    
        if(mask(i, j) ~= 0)
            % right
            if(j < (col - 1) && mask(i, j + 1) == set_val)
                mask(i, j) = set_val;
            % above
            elseif(i > 1 && mask(i - 1, j) == set_val)
                mask(i, j) = set_val;
            % left
            elseif(j > 1 && mask(i, j - 1) == set_val)
                mask(i, j) = set_val;
            % below
            elseif(i < (row - 1) && mask(i + 1, j) == set_val)
                mask(i, j) = set_val;
            end
        end
    end
    
    % loop through backwards in case anything was missed
    for j = col : -1 : 1    
        if(mask(i, j) ~= 0)
            % right
            if(j < (col - 1) && mask(i, j + 1) == set_val)
                mask(i, j) = set_val;
            % above
            elseif(i > 1 && mask(i - 1, j) == set_val)
                mask(i, j) = set_val;
            % left
            elseif(j > 1 && mask(i, j - 1) == set_val)
                mask(i, j) = set_val;
            % below
            elseif(i < (row - 1) && mask(i + 1, j) == set_val)
                mask(i, j) = set_val;
            end
        end
    end
end


% set the found region pixels from region_mask to reg_num
mask(find(mask == set_val)) = reg_num;

% copy into return variable
region_mask = mask;
