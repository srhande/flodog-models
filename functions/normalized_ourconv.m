% convolve two images using fft's
% pads things using the value in pad
%
% 9/26/05 -- (PH) now returns answer in type single if you hand it singles
% 9/26/05 -- (AR) simplified code
%
% filtered = ourconv (image, filter, pad)
function filtered = normalized_ourconv (image, filter, pad)

% check for singles
if(isa(image, 'single') || isa(filter, 'single'))
    name = 'single';
else
    name = 'double';
end

% pad the images
s_filt = size(filter);
s_img = size(image);

% appropriate padding depends on context
pad_img = ones(s_img(1) + s_filt(1), ...
    s_img(2) + s_filt(2), name) * pad; % mean(image(:));

pad_img(1 : s_img(1), 1 : s_img(2)) = image;

pad_filt = zeros(s_img(1) + s_filt(1), ...
    s_img(2) + s_filt(2), name);

pad_filt(1 : s_filt(1), 1 : s_filt(2)) = filter;

% Paul's slightly corrected version
temp = real(ifft2(fft2(pad_img) .* fft2(pad_filt)));

warning('off','MATLAB:colon:nonIntegerIndex')
% extract the appropriate portion of the filtered image
filtered = temp(1 + s_filt(1) / 2 : end - s_filt(1) / 2, ...
    1 + s_filt(2) / 2 : end - s_filt(2) / 2);
warning('on','MATLAB:colon:nonIntegerIndex')

% normalize result
image_selfcomp = sum(pad_img(:) .* pad_img(:));
filter_selfcomp = sum(pad_filt(:) .* pad_filt(:));
comparison_denom = sqrt(image_selfcomp * filter_selfcomp);
filtered = filtered ./ comparison_denom;
