function [ X_axis, Y_axis, data_new ] = RebinSparse_2D( X, Y, data, dX, dY )
% Rebin_2D : rebin 3D data of X, Y, data and bin width dX, dY.
%   Detailed explanation goes here
%   input: 
%   X, Y    : horizental and vertical grid matrix, same size of data
%   data    : data matrix
%   dX, dY  : bin size for horizental and vertical axis
%   output:
%   X_axis, Y_axis :  row and col vector, from min to max value of X and Y
%   with step dX and dY
%   data_new       :  sparse matrix (accumulated) with size of
%   length(Y_axis)*length(X_axis)
%   accumulated data_new matrix need to be normalized.

X_min = min(min(X));
X_max = max(max(X));
Y_min = min(min(Y));
Y_max = max(max(Y));

X_axis = [X_min:dX:X_max+dX];
Y_axis = [Y_min:dY:Y_max+dY]';
%% convert X and Y value to col and row indexes 
X2colind = ceil((tth_mat-X_min)/dX)+1;
Y2rowind = ceil((gam_mat-Y_min)/dY)+1;

data_new = sparse(Y2rowind,X2colind,data);
% cts = sparse(Y2rowind,X2colind,data./data);
% data_new = data_new./cts;


end

