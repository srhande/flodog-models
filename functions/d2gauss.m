% Function "d2gauss.m":
% This function returns a 2D Gaussian filter with size n1*n2; theta is 
% the angle that the filter rotated counter clockwise; and std1 and
% std2 are the standard deviation of the gaussian functions.
% std2 is the length of the filter along the rotated axis. 
% updated by Paul Hammon 10/8 to allow for n1 ~= n2

function h = d2gauss(n1,std1,n2,std2,theta)

% rotation transformation
r=[cos(theta) -sin(theta)
   sin(theta)  cos(theta)];

% create X and Y grids
Xs = repmat((-(n1-1)/2):(n1/2),n2,1);
Ys = repmat([(-(n2-1)/2):(n2/2)]',1, n1);

% reshape into vectors
Xs = reshape(Xs, 1,n1*n2);
Ys = reshape(Ys,1,n1*n2);
coor = r * [Xs; Ys];

% compute 1-D gaussians
gausX = gauss(coor(1,:),std1);
gausY = gauss(coor(2,:),std2);

% element-wise multiplication creates 2-D gaussians
h = reshape(gausX.*gausY,n2,n1);
h = h / sum(sum(h));