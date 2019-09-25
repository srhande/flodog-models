function [ padded_filter ] = pad_filter2( filter, max_size_h, max_size_w )
%PAD_FILTER pads filter to make it square
%   pads filter as needed with zeros on all sides to make it square with
%   sides of size parameter.  This is an attempt to even out the filter
%   responses so that all orientations give the same maximum response value
%
%  parameters:
%   filter: the filter to be padded
%   max_size (integer): the size the filter is to be padded to


[filter_x, filter_y] = size(filter);
% filter_x = filter_size(1);
% filter_y = filter_size(2);

if filter_x < max_size_h
    diff = max_size_h - filter_x;
    if diff == 1
        vert_padded_filter = [zeros(1, filter_y); filter];
    else  %size difference greater than 1
        padding_size = max_size_h - filter_x;
        if mod(padding_size, 2) %number is odd
            lower_pad = floor(padding_size/2);
            upper_pad = lower_pad + 1;
            vert_padded_filter = [zeros(upper_pad, filter_y); filter; zeros(lower_pad, filter_y)];
        else  %number is even
            lower_pad = padding_size/2;
            upper_pad = lower_pad;
            vert_padded_filter = [zeros(upper_pad, filter_y); filter; zeros(lower_pad, filter_y)];
        end
    end
else %filter has <size> number of rows
    vert_padded_filter = filter;  %no vertical padding necesssary
end

[vert_size_h, ~] = size(vert_padded_filter);

if filter_y < max_size_w
    diff = max_size_w - filter_y;
    if diff == 1
        padded_filter = [zeros(vert_size_h, 1), vert_padded_filter];
    else  %size difference greater than 1
        padding_size = max_size_w - filter_y;
        if mod(padding_size, 2) %number is odd
            right_pad = floor(padding_size/2);
            left_pad = right_pad + 1;
            padded_filter = [zeros(vert_size_h, left_pad), vert_padded_filter, zeros(vert_size_h, right_pad)];
        else  %number is even
            right_pad = padding_size/2;
            left_pad = right_pad;
            padded_filter = [zeros(vert_size_h, left_pad), vert_padded_filter, zeros(vert_size_h, right_pad)];
        end
    end
else %filter has <size> number of columns
    padded_filter = vert_padded_filter;  %no horizontal padding necesssary
end


end

