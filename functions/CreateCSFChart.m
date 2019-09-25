function [CSFImage limitLine] = CreateCSFChart(Xsize, Ysize, NcycLow, NcycHigh, CT_low, CT_high, centre, scale, LimitForBpc)
% [CSFImage limitLine] = CreateCSFChart(Xsize, Ysize [, NcycLow][, NcycHigh][, CT_low][, CT_high][, centre][, scale] [, LimitForBpc])
%
% Creates a image matrix with a chart of the "Campbell-Robson Contrast
% Sensitivity Function" (aka CSF-Chart). The matrix contains values between
% 0.0 for minimum output intensity and 1.0 for maximum output intensity.
%
% Input parameters (Most are optional and have reasonable defaults):
%
% Xsize == Width of chart in pixels.
% Ysize == Height of chart in pixels.
%
% Optional:
% NcycLow - NcycHigh == Spatial frequency range.
% CT_low - CT_high   == Contrast range.
% centre = Intensity value for pixels with zero contrast.
% scale = constrast range around centre.
%
% LimitForBpc == Assumed bit depths of display -> Used to calculate the
% 'limitLine' return argument -- The pixel row above which there is no
% useful content anymore, due to limited bit resolution of output device.
%
% CSFImage itself is the Ysize x Xsize double matrix with luminance values.

if nargin < 2
    error('Must provide at least XSize and YSize of chart in pixels!');
end

% Spatial frequency Range definitions
if ~exist('NcycLow', 'var')
    NcycLow = 1.0;
end

if ~exist('NcycHigh', 'var')
    NcycHigh = 77.0;
end

% Contrast range definitions
if ~exist('CT_low', 'var')
    CT_low  = (1.0/512.0);
end

if ~exist('CT_high', 'var')
    CT_high =  1.0;
end

if ~exist('centre', 'var')
    % centre is the neutral color, scale is the total range around
    % 'centre', ie., all values will be in interval [centre-scale ; centre+scale].
    %
    % 'centre' is chosen as 127/255 instead of 0.5, ie. slighly less than 50%
    % linear output intensity. The reason for this is because in 8 bpc
    % mode, the 50% point (=0.5) can't be hit spot-on, as it would
    % correspond to the 8 bit value 127.5 which is not representable with
    % an integral number.
    %
    % Therefore we need to go for either 127 or 128 to get the same
    % "neutral" base value for both 8 bit and 14 bit mode...
    centre = 127/255;
end

if ~exist('scale', 'var')
    scale  = centre;
end

if ~exist('LimitForBpc', 'var')
    LimitForBpc = 8;
end

% Multiplying factor per step for sweeping contrast.
CTbump = (CT_high/CT_low)^(1.0/Ysize);

% Increase spatial frequency by this factor for each point.
SFbump = (NcycHigh/NcycLow)^(1.0/Xsize);

% initialize contrast to the lowest value
Contrast = CT_low / CTbump;

% Preallocate matrix:
CSFImage = zeros(Ysize, Xsize);

% Fill matrix with content:
for i=0:Ysize-1
    Contrast = Contrast * CTbump;  % increase contrast by a constant factor
    currentSF = (NcycLow/Xsize) / SFbump;     % intialize to base lowest SF

    % 'limitLine' is the pixel row where Contrast drops below the level that
    % can be diplayed on a 'LimitForBpc' bpc display:
    if (Contrast < 1.0/(2^(LimitForBpc-0)))
        limitLine = i;
    end

    % Draw a line of swept-frequency sine wave data:
    for j=0:Xsize-1
        % Increase spatial frequency by constant factor:
        currentSF = currentSF * SFbump;

        % Calculate current linear value. Gamma encoding is done by PTB
        % online, so no need to encode it into matrix:
        CSFImage(i+1, j+1) =  centre + Contrast * sin(j*currentSF*2.0*pi) * scale;
    end
end

% Done.
return;
end

