function peaks = Peakhunting( data, thres, bins, sigma, err)
%  Peakhunting : find peaks in a given 2D image, based on local maximal method.
%  Detailed explanation goes here
%  Input: 
%   data  : image matrix.
%   thres : optional, threshold to find peaks, 
%   bins  : optional, bins steps, both x and y pixel use the same bins
%   sigma : optional, multiply of the error bar of the data
%   err   : optional, errorbar of the data, same size of data.
%  Output:
%   peaks : finded peaks, n*2 matrix, [id_row, id_col];

%  Syntax: 
%   1) peaks = Peakhunting( data)
%     Using default threshold, max([min(max(mat_data,[],1))  min(max(mat_data,[],2))])
%   2) peaks = Peakhunting( data, thres), e.g. peaks = Peakhunting( data, 0.1)
%     the threshold is given by user
%   3) peaks = Peakhunting( data, thres, bins)  e.g. peaks = Peakhunting( data, 0.1, 10)
%     the data will been bined fisrt to smooth data, then find peaks above
%     thres based on local maximal.
%   4) peaks = Peakhunting( data, thres, bins, sigma) e.g. peaks = Peakhunting( data, 0, 10,  4)
%     the data will been bined according given steps, then threshold will
%     be based on the multiplied errorbar for each point: sigma*err. the
%     errorbar will be propagated automatically. Here, thres will be
%     constant background.
%   5) peaks = Peakhunting( data, thres, bins, sigma, err), e.g. peaks = Peakhunting( data, 0, 10, 4, err)
%     Both data and err are inputed, and bined based on bins steps,
%     errorbar will be propagated automatically. thres will be constant
%     backgroud.

%% find peaks:
if nargin == 1 
    threshold = max([min(max(mat_data,[],1))  min(max(mat_data,[],2))]); % default threshold;
    peaks = localmax(data, threshold);    
elseif nargin == 2 
    threshold = thres;
    peaks = localmax(data, threshold);  
elseif nargin == 3 
    bins = floor(bins/1);
    if bins == 1 
        threshold =thres;
        peaks = localmax(data, threshold); 
    elseif bins > 1
        data_bins = rebindata(data,bins)/bins^2;
        threshold =thres;
        peaks = localmax(data_bins, threshold);
        if ~isempty(peaks)
            peaks = recover_pixel_position_1(peaks, data, bins);
        end
    end
elseif nargin == 4
    bins = floor(bins/1); % force bins to integer
    if bins == 1
        data = data - thres;   % thres as constant background
        data(data<0) = 0;
        err = real(sqrt(data));
        threshold = sigma*err;
        peaks = localmax(data, threshold);
    elseif bins > 1
        data = data - thres;
        data(data<0) = 0;
        data_bins = rebindata(data, bins);
        err_bins = real(sqrt(data_bins)/bins^2);
        data_bins = data_bins/bins^2; % normalize data matrix by bin pixel number.
        %data_bins(1:20,1:20)
        threshold = sigma*err_bins;
        peaks = localmax(data_bins, threshold);
        if ~isempty(peaks)
            peaks = recover_pixel_position_1(peaks, data, bins);
        end
    end   
elseif nargin == 5
    bins = floor(bins/1);
    if bins == 1
        data = data - thres;   % thres as constant background
        data(data<0) = 0;
        threshold = sigma*err;
        peaks = localmax(data, threshold);      
    elseif bins >1
        data = data - thres;
        data(data<0) = 0;
        [data_bins, err_bins] = rebindataerr(data, bins, err);
        data_bins = data_bins/bins^2;
        err_bins = err_bins/bins^2;
        threshold = sigma*err_bins;
        peaks = localmax(data_bins, threshold);
        if ~isempty(peaks)
            peaks = recover_pixel_position_1(peaks, data, bins);
        end        
    end 
else    
    warming('please input correctly !');
    return;        
end    


end


%% subfunctions
function data_bins = rebindata(data, bins)
% rebin data with pixels bins*bins to one new pixel by sum them.
[m,n] = size(data);
data_colbins = data(:,1:bins:floor(n/bins)*bins);
% bin cols
for ii = 2:bins
    data_colbins = data_colbins + data(:,ii:bins:floor(n/bins)*bins);
end
% bin rows
data_rowbins = data_colbins(1:bins:floor(m/bins)*bins,:);
for ii = 2:bins
    data_rowbins = data_rowbins + data_colbins(ii:bins:floor(m/bins)*bins,:);
end
data_bins = data_rowbins;

end

%
function [data_bins, err_bins] = rebindataerr(data, bins, err)
% rebin data and error with pixels bins*bins to one new pixel by sum them.
if all(size(data) == size(err))
    [m,n] = size(data);
    data_colbins = data(:,1:bins:floor(n/bins)*bins);
    err_colbins = err(:,1:bins:floor(n/bins)*bins);
    % bin cols
    for ii = 2:bins
        data_colbins = data_colbins + data(:,ii:bins:floor(n/bins)*bins);
        err_colbins = sqrt( err_colbins.^2 + err(:,ii:bins:floor(n/bins)*bins).^2 );
    end
    % bin rows
    data_rowbins = data_colbins(1:bins:floor(m/bins)*bins,:);
    err_rowbins = err_colbins(1:bins:floor(m/bins)*bins,:);
    for ii = 2:bins
        data_rowbins = data_rowbins + data_colbins(ii:bins:floor(m/bins)*bins,:);
        err_rowbins = sqrt( err_rowbins.^2 + err_colbins(ii:bins:floor(m/bins)*bins,:).^2 );
    end
    data_bins = data_rowbins;
    err_bins = err_rowbins;
else
    warming('dim of data and err must be the same, please check!');
    return
end    

end

%
function positions = localmax(mat_data, threshold)
% find local maximal of matrix mat_data by compare the neighbours(left,right,upper,lower)
mat_left  = [mat_data(:,2:end), mat_data(:,end)];
mat_right = [mat_data(:,1), mat_data(:,1:end-1)];
mat_upper = [mat_data(2:end,:); mat_data(end,:)];
mat_lower = [mat_data(1,:); mat_data(1:end-1,:)];

[id_row,id_col] = find(mat_data >0 &...
                       mat_data-mat_left >=0 &...
                       mat_data-mat_right >=0 &...
                       mat_data-mat_upper >=0 &...
                       mat_data-mat_lower >=0 &...
                       mat_data >= threshold);
                   
positions = [id_row,id_col];
end

%
function peaks_orig = recover_pixel_position_1(peaks, data, bins)
% recover the peak pixel position in original matrix 'data'
peaks_orig = zeros(size(peaks,1),2);
for ii = 1:size(peaks,1)
    id_row_orig = (peaks(ii,1)-1)*bins+1;
    id_col_orig = (peaks(ii,2)-1)*bins+1;
    peak_mat = data(id_row_orig:id_row_orig+bins-1, id_col_orig:id_col_orig+bins-1);
    int_max = max(max(peak_mat));
    [a,b] = find(peak_mat==int_max);
    if length(a) >1
        a = floor(mean(a));
        b = floor(mean(b));
    end
    peaks_orig(ii,:) = [id_row_orig+a-1, id_col_orig+b-1];
end
end

%
function peaks_orig = recover_pixel_position_2(peaks, data, bins)
% recover the peak pixel position in original matrix 'data'
% use extended roi to find proper index of the pixel. still doesnot work.
peaks_orig = zeros(size(peaks,1),2);
extend_start = 2;
extend_end = 2;
for ii = 1:size(peaks,1)
    id_row_orig = (peaks(ii,1)-1)*bins+1;
    id_col_orig = (peaks(ii,2)-1)*bins+1;
    center_row = id_row_orig+floor(bins/2);
    center_col = id_col_orig+floor(bins/2);
    row_start = center_row-extend_start*bins;
    row_end = center_row+extend_end*bins;
    col_start = center_col-extend_start*bins;
    col_end = center_col+extend_end*bins;
%     row_start:row_end
%     col_start:col_end
    peak_mat = data(row_start:row_end, col_start:col_end);
%     int_max = max(max(peak_mat));
%     [a,b] = find(peak_mat==int_max)
    int_mean = mean(mean(peak_mat));
    [a,b] = find(peak_mat > int_mean);
    if length(a) >1
        idpixels = find(peak_mat > int_mean);
        idaveg = floor(sum(idpixels.* peak_mat(idpixels))/ sum(peak_mat(idpixels)));
        m = size(peak_mat,2);
        a = mod(idaveg,m);
        b = floor(idaveg/m)+1;

    end
    peaks_orig(ii,:) = [row_start+a-1, col_start+b-1];
end
end