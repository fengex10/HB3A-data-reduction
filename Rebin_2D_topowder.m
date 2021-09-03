function [ X_axis, data_new ] = Rebin_2D_topowder( X, Y, data, dX, Yrange )
% Rebin_2D : rebin 3D data of X, Y, data and bin width dX, dY.
%   Detailed explanation goes here
%   input: 
%   X, Y    : horizental and vertical grid matrix, same size of data
%   data    : data matrix
%   dX, dY  : bin size for horizental and vertical axis
%   Yrange  : vector, [Ymin, Ymax],for range of Y to be integrated. 
%   output:
%   X_axis  :  row vector, from min to max value of X
%   with step dX
%   data_new       :  rebined data vector size with length(X_axis)


X_min = min(min(X));
X_max = max(max(X));
%Y_min = min(min(Y));
%Y_max = max(max(Y));

X_new = [X_min:dX:X_max];
%Y_new = [Y_min:dY:Y_max]';
%%
data_new = zeros(1, length(X_new)-1);
for ii = 1:length(X_new)-1
    idx = find(X_new(ii)<X & X<=X_new(ii+1));
    
    idy = find(min(Yrange)<=Y & Y<=max(Yrange)); 
    id = intersect(idx,idy);
    if isempty(id)
        data_new(ii) = NaN;
    else
        data_new(ii) = sum(sum(data(id)))/numel(data(id));
    end
      
    fprintf('Rebin powder completed: %d/%d\n',ii,length(X_new));  
end

X_axis = X_new(1:end-1)+dX/2;


end

