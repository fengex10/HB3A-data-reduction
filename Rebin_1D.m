function [ X_new, Y_new, err_new ] = Rebin_1D( X, Y, err, dX )
% Rebin_1D : rebin 1D data of X, Y, err and bin width dX.
%   Detailed explanation goes here
%   input: 
%   X, Y    : independent variable and dependent variable
%   err     : error bar
%   dX      : bin size for independent variable
%   output:


X_min = min(X);
X_max = max(X);

X_list = [X_min:dX:X_max];

%%
X_new = zeros(length(X_list)-1);
Y_new = zeros(length(X_list)-1);
err_new = zeros(length(X_list)-1);

for ii = 1:length(X_list)-1
    idx = find(X_list(ii)<X & X<X_list(ii+1));
    n = length(idx);
    X_new(ii) = sum(X(idx))/n;
    Y_new(ii) = sum(Y(idx))/n;
    err_new(ii) = sqrt(sum(err(idx).^2))/n;

end

end

