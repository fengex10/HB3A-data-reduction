function theStruct = SPICExml2struct(xmlfilename)
%% read the xml file, and return structure type data
%   Syntax:  theStruct = SPICExml2struct('HB3A_exp727_scan0055_0007.xml')
%   Input : xmifilename, string, path can be include.
%   Output: theStruct, structure type data, including below fields:
%
%   theStruct.time      : counting time, double, in sec
%   theStruct.monitor   : monitor counts, double, in cts
%   theStruct.twotheta  : 2theta, double, in deg
%   theStruct.omega     : omega, double, in deg
%   theStruct.chi       : chi, double, in deg
%   theStruct.phi       : phi, double, in deg
%   theStruct.det_trans : detector translation position, double, in mm.
%   theStruct.H         : sample index h
%   theStruct.K         : sample index k
%   theStruct.L         : sample index l
%   theStruct.data      : Intensity matrix, size defined by det_shape
%   theStruct.data_err  : Calculated errorbar.
%   theStruct.det_shape : detector pixels size, 2*1 vector, 

%% check file opening
fxml = fopen(xmlfilename, 'r');
if fxml ==-1
    warning([xmlfilename,' cannot be open!']);
    return
end 

theStruct = struct();
%% load instrument parameters, keyword must involve '<'.
% counting timer and monitor counts
theStruct.xmlname   = xmlfilename;

theStruct.time      = pick_instru_para(fxml, '<_time');      % counting time, unit: sec
theStruct.monitor   = pick_instru_para(fxml, '<_monitor');   % monitor counts
% motor position
theStruct.twotheta  = pick_instru_para(fxml, '<_2theta');    % 2theta, in deg
theStruct.omega     = pick_instru_para(fxml, '<_omega');     % omega, in deg
theStruct.chi       = pick_instru_para(fxml, '<_chi');       % chi, in deg
theStruct.phi       = pick_instru_para(fxml, '<_phi');       % phi, in deg
theStruct.det_trans = pick_instru_para(fxml, '<_det_trans'); % detector translation position, in mm.
% sample index (UB pre-defined)
theStruct.H         = pick_instru_para(fxml, '<_h');         % sample index h
theStruct.K         = pick_instru_para(fxml, '<_k');         % sample index k
theStruct.L         = pick_instru_para(fxml, '<_l');         % sample index l

%% load 2D area detector data, reture 
% while ~strcmp(fscanf(fxml,'%s',1),'<Detector')
% end

while ~feof(fxml)
    tline = fgetl(fxml);
    if contains(tline,'<Detector') 
        break 
    end
end


%tline = fgetl(fxml);
dt = strsplit(tline,{',','[',']'});
datashape = [str2num(dt{end-2}),str2num(dt{end-1})];
xmlData = textscan(fxml,'%f');
xmlData = reshape(xmlData{1,1},[datashape(2),datashape(1)]);

theStruct.data = xmlData;                                % Intensity matrix, size defined by det_shape
theStruct.data_err = sqrt(xmlData);                      % Calculate errorbar.
theStruct.det_shape = [datashape(2),datashape(1)];                          % detector pixels size


frewind(fxml);  % reset the read position indicator back to the begining of the file
%%
fclose(fxml);

end



function params = pick_instru_para(fxml, keyword)
%% return the instrument parameter based on the keyword
%  Syntax   : timer = pick_instru_para(fxml, '<_time')
%  fxml     : opened file identifier, fxml = fopen('xmlfilename')
%  keyword  : string, must involve '<', e.g. '<_time'

% find the line involving keyword, e.g. '<_time'
while ~feof(fxml)
    tline = fgetl(fxml);
    if contains(tline,keyword) 
        break 
    end
end

id1 = strfind(tline, '">');   % left position of values
id2 = strfind(tline, '</');   % right position of values
params = str2double(tline(id1+2:id2-1)); % extract values
frewind(fxml)  % reset the read position indicator back to the begining of the file

end