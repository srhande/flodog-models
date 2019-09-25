function im = sinGrating(vhSize, cyclesPer100Pix, orientation, phase, mean, amplitude)
% from Yuki Kamitani's image tools, downloaded from
% http://www.cns.atr.jp/~kmtn/imageMatlab/
%
% Draw sinusoidal grating and returns imgage matrix
% im = sinGrating(vhSize, cyclesPer100Pix, orientation, phase, mean, amplitude)
% vhSize: size of pattern, [vSize hSize]
% cyclesPer100Pix: cycles per 100 pixels
% phase: phase of grating in degree
% mean: mean color value
% amplitude: amplitude of color value
% orientation: orientation of grating, 0 -> horizontal, 90 -> vertical
%
% last modified 12/17/98 (c) Yukiyasu Kamitani
% 
% eg >imshow(sinGrating([200 200], 2, 90, 0, 0.5, 0.2))
% 

%orientation = orientation+90;

X = ones(vhSize(1),1)*[-floor(vhSize(2)/2):floor(vhSize(2)/2)];
Y = [-floor(vhSize(1)/2):floor(vhSize(1)/2)]' * ones(1,vhSize(2));	

% if vhSize is even, we need to delete a row or column
if size(X,2) > size(X,1)
    X = X(1:end, 2:end);
    Y = Y(2:end, 1:end);
end
    

simIm = amplitude * sin(2.*pi.*(cyclesPer100Pix/100).* (cos(orientation * pi/180).*X ...
										  + sin(orientation * pi/180).*Y)  ...
						                  - (phase * pi/180)*ones(vhSize) ); 
im = simIm + mean * ones(vhSize);
% max(max(im))
% min(min(im))
