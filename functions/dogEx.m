%    dogEx makes a Difference of Gaussians filter, with more options than
%    Dog

%     r,c: # of rows and columns

%     rf,cf: row and column stds (space constant)

%     sr1, sr2 (spread ratio):  wide spatial spread / narrow one (1,2 == subtracted
%     gaussian is twice the sd of the positive one).


%     rotate by theta (radians)

% centerWeight : how much greater weight the postive center gets


function result =  dogEx(r, c, rf, cf, sr1, sr2, theta, centerWeight )

  result=centerWeight*d2gauss(r,rf,c,cf,theta)-d2gauss(r,rf*sr1,c,cf*sr2,theta) ;



%---------end filtdog-------------------------





