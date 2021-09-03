function datStruct = loaddatfile( datfilename )
% read the *.dat file, and return structure type data
%   Syntax:  datStruct = loaddatfile('HB3A_exp0727_scan0055.dat')
%   Input :  datfilename, string, path can be include.
%   Output:  datStruct, structure type data, including below fields:
%
%   datStruct.wavelength   : double, neutron wavelength, in A, 
%   atStruct.def_x         : string, scan indenpentence, e.g. 'omega' scan
%   datStruct.xmlfiles     : n*1 cell, individual xml file name for each scan point
%   datStruct.Pt_list      : n*1 vector, scan point index list.
%   datStruct.omega_list   : n*1 vector, omega list for scan
%   datStruct.H_list       : n*1 vector, H list of scan
%   datStruct.K_list       : n*1 vector, K list of scan
%   datStruct.L_list       : n*1 vector, L list of scan
%% --------main function---------
fdat = fopen(datfilename, 'r');
datStruct = struct();
% check file opening
if fdat ==-1
    warning([datfilename,' cannot be open!']);
    return
end
%% ------------get info from headers-----------
while ~feof(fdat)
    tline = fgetl(fdat);
    if contains(tline,'# wavelength')
        wave = strsplit(tline);
        datStruct.wavelength = str2double(wave{end});   % obtain wavelength
    elseif contains(tline, '# def_x')
        def_x = strsplit(tline);
        datStruct.def_x = def_x{end};                   % obtain the scan axis
    end
end

frewind(fdat); % reset the read position indicator back to the begining of the file

%% ----------get data----------- 
% --------get col names---------
while ~feof(fdat)
    tline = fgetl(fdat);
    if contains(tline,'# col_headers =') 
        tline = fgetl(fdat);
        break 
    end
end
colnames = strsplit(tline, {' ','.'});
colnames = colnames(2:end);

% ---------get data matrix and xml file names--------
xmlfiles = {};
data = [];
n=0;
while ~feof(fdat)
    tline = fgetl(fdat);
    if strcmp(tline(1),'#')        
        continue 
    end
    n = n+1;
    tline = strsplit(tline);
    %xmlfiles{n} = tline{end};
    xmlfiles = [xmlfiles;tline{end}];
    dataline = str2double(tline(2:end-1));
    data = [data;dataline];
end 
frewind(fdat)
% ----attribute value to datStruct;
datStruct.xmlfiles = xmlfiles;

isttheta = cellfun(@(x)isequal(x,'2theta'),colnames);
datStruct.ttheta_list = data(:,find(isttheta));

isomega = cellfun(@(x)isequal(x,'omega'),colnames);
datStruct.omega_list = data(:,find(isomega));

% ischi = cellfun(@(x)isequal(x,'chi'),colnames);
% datStruct.chi_list = data(:,find(ischi));

% isphi = cellfun(@(x)isequal(x,'phi'),colnames);
% datStruct.phi_list = data(:,find(isphi));

isPt = cellfun(@(x)isequal(x,'Pt'),colnames);
datStruct.Pt_list = data(:,find(isPt));

isH = cellfun(@(x)isequal(x,'h'),colnames);
datStruct.H_list = data(:,find(isH));

isK = cellfun(@(x)isequal(x,'k'),colnames);
datStruct.K_list = data(:,find(isK));

isL = cellfun(@(x)isequal(x,'l'),colnames);
datStruct.L_list = data(:,find(isL));

% iscoldtip = cellfun(@(x)isequal(x,'coldtip'),colnames);
% datStruct.coldtip = data(:,find(iscoldtip));

istime = cellfun(@(x)isequal(x,'time'),colnames);
datStruct.time = data(:,find(istime));

% ishorz = cellfun(@(x)isequal(x,'horz'),colnames);
% datStruct.horz = data(:,find(ishorz));

% isroi0 = cellfun(@(x)isequal(x,'roi0'),colnames);
% datStruct.roi0 = data(:,find(isroi0));
% 
% isroi1 = cellfun(@(x)isequal(x,'roi1'),colnames);
% datStruct.roi1 = data(:,find(isroi1));
% 
% isroi2 = cellfun(@(x)isequal(x,'roi2'),colnames);
% datStruct.roi2 = data(:,find(isroi2));
% 
% isroi3 = cellfun(@(x)isequal(x,'roi3'),colnames);
% datStruct.roi3 = data(:,find(isroi3));
% 
% isroi4 = cellfun(@(x)isequal(x,'roi4'),colnames);
% datStruct.roi4 = data(:,find(isroi4));
% 
% isroi5 = cellfun(@(x)isequal(x,'roi5'),colnames);
% datStruct.roi5 = data(:,find(isroi5));


%%
fclose(fdat);
end