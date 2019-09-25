function [ grating ] = flatten_grating( grating )
%FLATTEN_GRATING takes a sinusoidal grating as input and quantizes it into
%1 or -1 values
%   Detailed explanation goes here

grating(grating > 0) = 1;
grating(grating < 0) = -1;

end

