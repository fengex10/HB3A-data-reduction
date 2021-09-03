function outStruct = XML2tthetagamma( xmlStruct, center_pixel )
% XML2tthetaphi : convert the detector pixel ID to position and (2theta, phi), 
% follows SPICExml2struct function. 
%   Input:  center_pixel: define detector center pixels [x_center, y_center], e.g. [256, 256];
%   
%   Output: outStruct, structure type data, including below fields:
%
%   outStruct.time      : counting time, double, in sec
%   outStruct.monitor   : monitor counts, double, in cts
%   outStruct.twotheta  : 2theta, double, in deg
%   outStruct.omega     : omega, double, in deg
%   outStruct.chi       : chi, double, in deg
%   outStruct.phi       : phi, double, in deg
%   outStruct.det_trans : detector translation position, double, in mm.
%   outStruct.H         : sample index h
%   outStruct.K         : sample index k
%   outStruct.L         : sample index l
%   outStruct.data      : Intensity matrix, size defined by det_shape
%   outStruct.data_err  : Calculated errorbar.
%   outStruct.det_shape : detector pixels size, 2*1 vector, 

%   outStruct.pixel_X   : pixel positions of X (horizental), matrix of det_shape
%   outStruct.pixel_Y   : pixel positions of Y (vertical), matrix of det_shape
%   outStruct.pixel_ttheta : 2 theta value of pixels, matrix of det_shape
%   outStruct.pixel_gamma  : gamma (lift angle) value of pixels, matrix of det_shape 

outStruct = xmlStruct;

pixel_size = 11.6*10/512; % mm
vertical_gap = 8; % mm
% calculate horizental position of pixels
x_block = 0:pixel_size:(512-1)*pixel_size;
x_lines = x_block - x_block(center_pixel(1));
pixel_X = repmat(x_lines, [xmlStruct.det_shape(1),1]); % assign x position for each pixel
% calculate vertical position of pixels
y_block = [0:pixel_size:(512-1)*pixel_size]';
y_lines = y_block;
for ii = 2:3 
    y_lines = [y_lines;y_block+(y_block(end)+vertical_gap)*(ii-1)];
end
y_lines = y_lines - y_lines(center_pixel(2));
pixel_Y = repmat(y_lines, [1,xmlStruct.det_shape(2)]); % assign y position for each pixel


% convert X-Y position to twotheta(ttheta)-phi 
alpha = 180-xmlStruct.twotheta;
D = xmlStruct.det_trans;
pixel_ttheta =180-acosd((pixel_X*sind(alpha)+D*cosd(alpha))./sqrt(D^2+pixel_X.^2+pixel_Y.^2)); 
               
a = (pixel_X*cosd(alpha)-D*sind(alpha));
b = a./abs(a);
c = acosd(-1*pixel_Y./sqrt(pixel_Y.^2+(pixel_X*cosd(alpha)-D*sind(alpha)).^2));
pixel_gamma = -1*(b.*c+90);

outStruct.pixel_X = pixel_X;
outStruct.pixel_Y = pixel_Y;
outStruct.pixel_ttheta = pixel_ttheta;
outStruct.pixel_gamma  = pixel_gamma;
end

