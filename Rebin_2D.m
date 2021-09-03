function [ X_axis, Y_axis, data_new ] = Rebin_2D( X, Y, data, dX, dY )
% Rebin_2D : rebin 3D data of X, Y, data and bin width dX, dY.
%   Detailed explanation goes here
%   input: 
%   X, Y    : horizental and vertical grid matrix, same size of data
%   data    : data matrix
%   dX, dY  : bin size for horizental and vertical axis
%   output:
%   X_axis, Y_axis :  row and col vector, from min to max value of X and Y
%   with step dX and dY
%   data_new       :  rebined data matrix with size of
%   length(Y_axis)*length(X_axis)

X_min = min(min(X));
X_max = max(max(X));
Y_min = min(min(Y));
Y_max = max(max(Y));

X_new = [X_min:dX:X_max];
Y_new = [Y_min:dY:Y_max]';
%%
data_new = zeros(length(Y_new)-1,length(X_new)-1);
for ii = 1:length(X_new)-1
    idx = find(X_new(ii)<X & X<=X_new(ii+1));
    for jj = 1:length(Y_new)-1
        idy = find(Y_new(jj)<Y & Y<=Y_new(jj+1)); 
        id = intersect(idx,idy);
        if isempty(id)
            data_new(jj,ii) = NaN;
        else
            data_new(jj,ii) = sum(sum(data(id)))/numel(data(id));
        end
    end   
    fprintf('Rebin 2D completed: %d/%d\n',ii,length(X_new)); 
end

X_axis = X_new(1:end-1)+dX/2;
Y_axis = Y_new(1:end-1)+dY/2;

end

