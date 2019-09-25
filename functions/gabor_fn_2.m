function gb=gabor_fn_2(bw,theta,lambda,psi,gamma, mean, amplitude, gSkew, gRot)
% from http://en.wikipedia.org/wiki/Gabor_filter
% parameters:
%   bw: spatial frequency bandwidth (in octaves): difference in octaves
%       between lowest frequency of sinusoidal stimulus that triggers a half-peak 
%       response and the highest such frequency
%   sigma (old, now calculated from bw): standard deviation of the gaussian envelope - effectively the
%       number of ON/OFF fields showing
%   theta: angle of orientation of the filter in degrees - should be
%       between 0 and 360
%   lambda: wavelength of the sinusoidal factor (in pixels) (preferred wavelength of
%       the filter) - must be greater than two
%   psi: phase offset in degrees - value should be between -180 and 180, 0
%       corresponds to center-ON, 180 corresponds to center-OFF, -90 and 90
%       correspond to filters with an ON/OFF pair in the center
%   gamma: spatial aspect ratio - value of 1 is a circular gabor function,
%       values less than one are typical - gamma = width/length, where width 
%       refers to the dimension crossing the ON/OFF fields, and length is the 
%       dimension parallel to the fields
%   mean: mean value of the sinusoidal grating portion (typically 0)
%   amplitude: amplitude above and below mean of the sinusoidal grating
%       portion (typically 1)
%   gSkew: amount (in pixels) that Gaussian is "skewed" left or right
%       compared to the sinusoid - all values are relative to a vertical
%       (0-degree) filter, with negative numbers skewing the Gaussian to
%       the left, positive numbers to the right
%   gRot: amount (in degrees) that the Gaussian is rotated compared to the
%       sinusoid (zero-centered)


sTheta = theta;             % sinusoidal grating's orientation
sTheta = sTheta * pi/180;   % converting to radians
gTheta = theta;             % capturing the value before conversion
theta = theta * pi/180;     % converting to radians

psi = psi * pi/180;         % converting to radians
sigma = (lambda/pi) * (sqrt(log(2)/2)) * (((2^bw)+1)/((2^bw)-1));
sigma_x = sigma;
sigma_y = sigma/gamma;
 
% Bounding box - find max and min values of X and Y for the given gabor
% filter size
nstds = 3;
xmax = max(abs(nstds*sigma_x*cos(theta)),abs(nstds*sigma_y*sin(theta)));
xmax = ceil(max(1,xmax)) * 2;
ymax = max(abs(nstds*sigma_x*sin(theta)),abs(nstds*sigma_y*cos(theta)));
ymax = ceil(max(1,ymax)) * 2;
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);

% convert meshgrid to sinusoidal grating
cyclerate = 1 / lambda;  % original formula asked for cycles per 100 pixels, then divided by 100
simIm = amplitude * cos(2.*pi.*cyclerate.* (cos(sTheta).*x + sin(sTheta).*y)  ...
						                  - (psi)*ones(size(x)) ); 
im = simIm + mean * ones(size(x));
% figure
% imshow(im)

% prep components of Gaussian formula
gTheta = (gTheta + gRot) * pi/180; % converting to radians
gSkew_x = gSkew * cos((2*pi) - theta); % x component of the skew
gSkew_y = gSkew * sin((2*pi) - theta); % y component of the skew
a = ((cos(gTheta)^2)./(2*(sigma_x^2))) + ((sin(gTheta)^2)./(2*(sigma_y^2)));
b = ((sin(2*gTheta)./(4*(sigma_x^2)))) - (sin(2*gTheta)./(4*(sigma_y^2)));
c = ((sin(gTheta)^2)./(2*(sigma_x^2))) + ((cos(gTheta)^2)./(2*(sigma_y^2)));

% create the Gaussian envelope
gb = exp(-(a.*((x-gSkew_x).^2) + 2*b.*(x-gSkew_x).*(y-gSkew_y) + c.*((y-gSkew_y).^2)));
% figure
% imshow(gb)

% multiply the sinusoidal grating and the Gaussian to get the result
gb = gb .* im;
% figure
% imagesc(gb)
% figure
% surf(gb, 'EdgeColor', 'none')
% 
% % Rotation 
% x_theta=x*cos(theta)+y*sin(theta);
% y_theta=-x*sin(theta)+y*cos(theta);
%  
% gb= exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
% %gb = exp(-((x_theta.^2 + (gamma^2.*y_theta.^2))./(2*(sigma^2)))) .* cosd((2*pi.*(x_theta./lambda)) + psi);
end
