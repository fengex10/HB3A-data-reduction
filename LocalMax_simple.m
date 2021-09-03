function Maxpositions = LocalMax_simple( mat_data, thres, sigma, mat_err)
% LocalMax_simple  : Find local maximal of the matrix 'mat_data'
%   Detailed explanation goes here
%   mat_data   :   input of image, matrix
%   thres      :   optional, threshold for peaks; if sigma is input, thres will be the constant background.
%   sigma      :   ratio of peak intensity and errorbar. sigma*mat_err will be threshold to identify peaks, e.g. 3
%   mat_err    :   error of mat_data, matrix with same size of mat_data. if not input, default error is mat_err = real(sqrt(mat_data));
%   Maxpositions  :  output peaks positions, 2 rows. [id_row,id_col]
%
% e.g. : Maxpositions = LocalMax_simple(mat_data)
%        Maxpositions = LocalMax_simple(mat_data, 0.1)
%        Maxpositions = LocalMax_simple(mat_data, 0, 2)
%        Maxpositions = LocalMax_simple(mat_data, 0, 3, mat_err)


%% asign default value
if nargin ==1 
    threshold = max([min(max(mat_data,[],1))  min(max(mat_data,[],2))]); % default threshold
elseif nargin ==2
    threshold = thres;
elseif nargin ==3 
    mat_data = mat_data-thres;  % if sigma is inputed, thres as constant background.
    mat_data(mat_data<0) = 0; 
    mat_err = real(sqrt(mat_data));
    threshold = sigma*mat_err;
elseif nargin ==4
    mat_data = mat_data-thres;
    mat_data(mat_data<0) = 0;
    threshold = sigma*mat_err;
else
    warming('number of input argues wrong!');
    return;
end
%% 
mat_left  = [mat_data(:,2:end), mat_data(:,end)];
mat_right = [mat_data(:,1), mat_data(:,1:end-1)];
mat_upper = [mat_data(2:end,:); mat_data(end,:)];
mat_lower = [mat_data(1,:); mat_data(1:end-1,:)];

[id_row,id_col] = find(mat_data-mat_left>0 &...
                       mat_data-mat_right>0 &...
                       mat_data-mat_upper>0 &...
                       mat_data-mat_lower>0 &...
                       mat_data >= threshold);
                   
Maxpositions = [id_row,id_col];                   
end

