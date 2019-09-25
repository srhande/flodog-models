function [  ] = generate_image( img, txt, filename, dir, cmap )
%GENERATE_IMAGE creates an image file from a given matrix, used for
%visualization of filter components
%   
% 5/19/14 Eric Morgan
%
% img -- matrix to be visualized
% text -- cell array of identifying text to appear on the image - each
%         element of the sell array will be displayed on its own line
% filename -- name of file the image will be saved as
% dir -- directory to save the file to
% cmap -- (optional) colormap to be used - uses greyscale if not specified

% Y_offset used to properly set text vertical placement if multiple lines
% are used
y_offset = length(txt) - 1;
y = 35 + (20 * y_offset);

h = figure;
imagesc(img);
colormap(cmap);
text(25,y,txt)
colorbar
%F = getframe(gcf);
%imwrite(F.cdata, [dir filename])
%clear F;
print([dir filename], '-dpng')
close(h)
end

