function varargout = HB3A_ScanViewer_V3(varargin)
% HB3A_ScanViewer_V3 MATLAB code for HB3A_ScanViewer_V3.fig
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HB3A_ScanViewer_V3

% Last Modified by GUIDE v2.5 02-Oct-2020 12:02:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HB3A_ScanViewer_V3_OpeningFcn, ...
                   'gui_OutputFcn',  @HB3A_ScanViewer_V3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HB3A_ScanViewer_V3 is made visible.
function HB3A_ScanViewer_V3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HB3A_ScanViewer_V3 (see VARARGIN)

% Choose default command line output for HB3A_ScanViewer_V3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HB3A_ScanViewer_V3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HB3A_ScanViewer_V3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% define global variables
global datStruct xmlStruct datadir datfiles_list
        datStruct = struct();
        xmlStruct = struct();
        datadir = string();
        datfiles_list = string();


% --- Executes on button press in setpath.
function setpath_Callback(hObject, eventdata, handles)
% hObject    handle to setpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global datStruct datadir datfiles_list

datadir = uigetdir;
datadir = [datadir,filesep];
set(handles.data_path, 'String', datadir);
datfiles_Struct= dir([datadir,'*.dat']);
a = struct2cell(datfiles_Struct);
datfiles_list = a(1,:)';
set(handles.dat_list, 'String', datfiles_list);
% 
% [datfile, datadir] = uigetfile('*.dat','Open a *.dat file');
% datfilename = [datadir, datfile];
% set(handles.data_path, 'String', datfilename);
% 
% datStruct = loaddatfile(datfilename);
% 
% set(handles.xml_list, 'String', datStruct.xmlfiles);



function data_path_Callback(hObject, eventdata, handles)
% hObject    handle to data_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_path as text
%        str2double(get(hObject,'String')) returns contents of data_path as a double


% --- Executes during object creation, after setting all properties.
function data_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dat_list.
function dat_list_Callback(hObject, eventdata, handles)
% hObject    handle to dat_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dat_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dat_list
global datfiles_list datadir datStruct

dat_file_number = get(hObject, 'value');
dat_file_name = [datadir, datfiles_list{dat_file_number}];
datStruct = loaddatfile(dat_file_name);
set(handles.xml_list, 'String', datStruct.xmlfiles);
set(handles.xml_list, 'Value', 1); % set xml_list default 'value' is 1.

% set default display, 1st scan pt
xml_file_name = [datadir, datStruct.xmlfiles{1}];
% xmlStruct = SPICExml2struct(xml_file_name);
plotdata(xml_file_name, handles)


% --- Executes during object creation, after setting all properties.
function dat_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dat_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ROI_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_edit as text
%        str2double(get(hObject,'String')) returns contents of ROI_edit as a double
%roi = get(hObject, 'string')




% --- Executes during object creation, after setting all properties.
function ROI_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in xml_list.
function xml_list_Callback(hObject, eventdata, handles)
% hObject    handle to xml_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xml_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xml_list
global datStruct xmlStruct datadir

xml_files = datStruct.xmlfiles;
xml_file_number = get(hObject, 'value');
xml_file_name = [datadir, xml_files{xml_file_number}];
plotdata(xml_file_name, handles)






% --- Executes during object creation, after setting all properties.
function xml_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xml_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function viewBG_SelectionChangedFcn(hObject, eventdata, handles)



function plotdata(xml_file_name, handles)

xmlStruct = SPICExml2struct(xml_file_name);

switch get(get(handles.viewBG, 'SelectedObject'), 'Tag')
    case 'detector'
        % plot data in axis
        psd_matrix = xmlStruct.data;
        clims = [0, max(max(psd_matrix))];
        imagesc(psd_matrix, 'Parent', handles.axes2, clims);
        colorbar
        colormap jet;
        set(gca, 'ydir','normal');
        set(gca, 'ylim', ([0,512*3]));
        xlabel(handles.axes2, 'X (Horizental) Pixel');
        ylabel(handles.axes2, 'Y (Vertical) Pixel');
        
        % plot ROI
        if ~isempty(get(handles.ROI_edit, 'String'))
            hold on
            roi = str2num(get(handles.ROI_edit, 'String'));
            roi_x = [roi(1), roi(2), roi(2), roi(1), roi(1)];
            roi_y = [roi(3), roi(3), roi(4), roi(4), roi(3)];
            plot(roi_x, roi_y, 'r-', 'LineWidth', 1, 'Parent', handles.axes2 );
            hold off            
        end
        
    case 'angle'
        %center_pixel = [256, 256];
        center_pixel = [256, 206];  %[x_center, y_center]
        xmlStruct = XML2tthetagamma( xmlStruct, center_pixel );
        psd_matrix = xmlStruct.data;
        ttheta = xmlStruct.pixel_ttheta;
        gamma = xmlStruct.pixel_gamma;
    
        surf(ttheta,gamma,psd_matrix,'Parent', handles.axes2);
        shading flat
        view(2);
        colorbar
        colormap jet
        caxis([0, max(max(psd_matrix))]);
        set(gca, 'ylim', ([min(min(gamma)),max(max(gamma))]));
        set(gca, 'xlim', ([min(min(ttheta)),max(max(ttheta))]));
        xlabel(handles.axes2, '2 Theta (deg)');
        ylabel(handles.axes2, 'Gamma (deg)');
        
        % plot ROI
        if ~isempty(get(handles.ROI_edit, 'String'))
            hold on
            %disp(get(handles.ROI_edit, 'String'))
            roi = str2num(get(handles.ROI_edit, 'String'));
            roi_x = [roi(1), roi(2), roi(2), roi(1), roi(1)]';
            roi_y = [roi(3), roi(3), roi(4), roi(4), roi(3)]';
            m = xmlStruct.det_shape(1); % detector row number;
            %n = xmlStruct.det_shape(2); % detector col number;
            roi_2theta = ttheta(roi_y+(roi_x-1)*m); % by the absolute index
            roi_gamma = gamma(roi_y+(roi_x-1)*m);            
            plot(roi_2theta, roi_gamma, 'r-', 'LineWidth', 1, 'Parent', handles.axes2 );
            hold off
        end
        
    case 'angleChi'
        
        
end
