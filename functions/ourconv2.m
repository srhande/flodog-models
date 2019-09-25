% convolve two images using fft's
% pads things using the value in pad
%
% 9/26/05 -- (PH) now returns answer in type single if you hand it singles
% 9/26/05 -- (AR) simplified code
%
% filtered = ourconv (image, filter, pad)
function filtered = ourconv2 (image, filter, pad)

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

%get max possible value from convolution for normalization by convolving
%with all 1s
norm_val = ones(size(pad_filt));
normconv = real(ifft2(fft2(abs(pad_filt)) .* fft2(norm_val)));
%normconvval = max(abs(normconv(:)));

% Paul's slightly corrected version
filt_fft = fft2(pad_filt);
%filt_fft = filt_fft ./ max(abs(real(filt_fft(:))));
img_fft = fft2(pad_img);
%img_fft = img_fft ./ max(abs(img_fft(:)));

temp = real(ifft2(img_fft .* filt_fft));

temp = temp ./ normconv;

warning('off','MATLAB:colon:nonIntegerIndex')
% extract the appropriate portion of the filtered image
filtered = temp(1 + s_filt(1) / 2 : end - s_filt(1) / 2, ...
    1 + s_filt(2) / 2 : end - s_filt(2) / 2);

warning('on','MATLAB:colon:nonIntegerIndex')