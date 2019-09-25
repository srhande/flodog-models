function [ trimfilt ] = trim_filt( filter, threshold )
%TRIM_FILT removes edge rows and columns containing very small values 
% surrounding the response fields of the gabor filter so that only the ON 
% and OFF fields of the gabor have active values, and empty bordering rows
% and columns are removed
%
% 1/26/15 Eric Morgan
% 5/26/15 Eric Morgan - modified to set values below the threshhold to zero


top = 1;
filtsize = size(filter);
bottom = filtsize(1);
left = 1;
right = filtsize(2);

% if the threshold is 0, make it smaller than the minimum value instead
% (otherwise things just get messy)
if threshold == 0
    threshold = min(abs(nonzeros(filter))) * 0.9;
end


%trim low-value rows from the top
while (max(filter(top, :)) < threshold) && (min(filter(top, :)) > -threshold)
    top = top + 1;
end

%trim low-value rows from the bottom
while (max(filter(bottom, :)) < threshold) && (min(filter(bottom, :)) > -threshold)
    bottom = bottom - 1;
end

%trim low-value columns from the left
while (max(filter(:, left)) < threshold) && (min(filter(:, left)) > -threshold)
    left = left + 1;
end

%trim low-value columns from the right
while (max(filter(:, right)) < threshold) && (min(filter(:, right)) > -threshold)
    right = right - 1;
end

trimfilt = filter(top:bottom,left:right);

% create a mask to get rid of small values near 0 above and below the
% threshold
trimfiltmask = trimfilt > threshold | trimfilt < -threshold;

%multiply the filter by the mask to only get the wanted values
trimfilt = trimfilt .* trimfiltmask;


end

