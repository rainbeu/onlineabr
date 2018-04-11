function varargout = OnlineABR(varargin)
% ONLINEABR MATLAB code for OnlineABR.fig
%      ONLINEABR, by itself, creates a new ONLINEABR or raises the existing
%      singleton*.
%
%      H = ONLINEABR returns the handle to a new ONLINEABR or the handle to
%      the existing singleton*.
%
%      ONLINEABR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONLINEABR.M with the given input arguments.
%
%      ONLINEABR('Property','Value',...) creates a new ONLINEABR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OnlineABR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OnlineABR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OnlineABR

% Last Modified by GUIDE v2.5 02-Jul-2013 10:53:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OnlineABR_OpeningFcn, ...
                   'gui_OutputFcn',  @OnlineABR_OutputFcn, ...
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


% --- Executes just before OnlineABR is made visible.
function OnlineABR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OnlineABR (see VARARGIN)

% Choose default command line output for OnlineABR
handles.output = hObject;

handles.Setup.hFigure             = hObject;

DefaultParameters;
handles.ParamFileName = 'DefaultParameters';
FileName = uigetfile('*.m','Please select parameter script','DefaultParameters.m');
if ~isempty(FileName) && ~isnumeric(FileName)
    [~,name] = fileparts(FileName);
    eval(name);
    handles.ParamFileName = name;
else
    fprintf('using default parameters\n');
end

handles.TimeAxes = [handles.axLeftEEG handles.axRightEEG handles.axBinEEG handles.axBinDiff handles.axLeftSig handles.axRightSig];
handles.EEGAxes = [handles.axLeftEEG handles.axRightEEG handles.axBinEEG handles.axBinDiff];
handles.SigAxes = [handles.axLeftSig handles.axRightSig];
handles.FreqAxes = [handles.axLeftFFT handles.axRightFFT];

items = arrayfun(@(x)sprintf('%1.1f',x/1e-6),handles.Setup.Stimulus.ITD,'UniformOutput',false);
set(handles.popITD,'String',items);

items = arrayfun(@(x)sprintf('%1.1f',x),handles.Setup.Stimulus.ILD,'UniformOutput',false);
set(handles.popILD,'String',items);

% Update handles structure
guidata(hObject, handles);

DisplayInfo(handles)
% UIWAIT makes OnlineABR wait for user response (see UIRESUME)
% uiwait(handles.figOnlineABR);




function figOnlineABR_CloseRequestFcn(hObject, eventdata, handles)
% uiresume(handles.figOnlineABR);

if playrec('isInitialised')
    playrec('reset')
end

delete(hObject);


function varargout = OnlineABR_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;



function tbnPlayRec_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.txtOnlineInfo,'String','');
    handles.Setup = PlayStimulus(handles.Setup,'DisplayCallback','FinishedCallback');
    msgbox('Recording finished','OnlineABR - recording','help','modal');
    guidata(hObject,handles);
end


function pbnDelete_Callback(hObject, eventdata, handles)


function tbnSetup_Callback(hObject, eventdata, handles)
FileName = uigetfile('*.m','Please select parameter script',[handles.ParamFileName '.m']);
if ~isempty(FileName) && ~isnumeric(FileName)
    [~,name] = fileparts(FileName);
    eval(name);
    handles.ParamFileName = name;
end
set(hObject,'Value',0);
items = arrayfun(@(x)sprintf('%1.1f',x/1e-6),handles.Setup.Stimulus.ITD,'UniformOutput',false);
set(handles.popITD,'String',items,'Value',1);
items = arrayfun(@(x)sprintf('%1.1f',x),handles.Setup.Stimulus.ILD,'UniformOutput',false);
set(handles.popILD,'String',items,'Value',1);
guidata(hObject,handles);
DisplayInfo(handles)


function DisplayInfo(handles)
Msg = sprintf(['Artefact threshold: %1.1f µV\n\n'...
              'Cal file: %s\n\n'...
              'Duration: %1.3f ms\n'...
              'Level: %1.1f dB SPL\n'...
              'Type: %s\n\n'...
              'Max Reps: %1.0f\n\n'],...
              handles.Setup.Recording.ArtefactThr,...
              handles.Setup.Hardware.CalFile,...
              handles.Setup.Stimulus.Duration/1e-3,...
              handles.Setup.Stimulus.Level,...
              handles.Setup.Stimulus.Type,...
              handles.Setup.Recording.MaxRepsPerCond);
switch handles.Setup.Stimulus.Type
    case 'tone'
        Msg = [Msg sprintf('Frequency: %1.1f Hz\n',handles.Setup.Stimulus.Frequency)];
    case 'wave'
        Msg = [Msg sprintf('File name: %s\n',handles.Setup.Stimulus.FileName)];
end
set(handles.txtSetupInfo,'String',Msg);



function [bRunning,ITDix,ILDix] = DisplayCallback(stSetup,Data,TimeOffset)
handles = guidata(stSetup.hFigure);
bRunning = get(handles.tbnPlayRec,'Value');
set(handles.txtOnlineInfo,'String',stSetup.Msg);
plot(handles.axLeftEEG ,stSetup.t_ms,Data(:,1),'b-');
plot(handles.axRightEEG,stSetup.t_ms,Data(:,2),'r-');
plot(handles.axBinEEG  ,stSetup.t_ms,Data(:,3),'k-',stSetup.t_ms,Data(:,9),'m-');
plot(handles.axBinDiff ,stSetup.t_ms,Data(:,4),'k-');
plot(handles.axLeftSig ,stSetup.t_ms,Data(:,[5 7]));
plot(handles.axRightSig,stSetup.t_ms,Data(:,[6 8]));
set(handles.TimeAxes,'xlim',[min(stSetup.t_ms) max(stSetup.t_ms)]);
set(handles.EEGAxes,'ylim',min(max([-1.1 1.1]*max(max(abs(Data(:,1:4)))),[-Inf 1]*2e-5),[-1 Inf]*2e-5));
set(handles.SigAxes,'ylim',min(max([-1.1 1.1]*max(max(abs(Data(:,5:6)))),[-Inf 1]*2e-5),[-1 Inf]*2e-5));
Spec = db(abs(fft(Data(:,5:6)/2e-5,stSetup.FFTSize)/(stSetup.FFTSize/2)));
semilogx(handles.axLeftFFT ,stSetup.f_Hz,Spec(:,1),'b-',...
                            stSetup.f_Hz,Spec(:,2),'r-');
set(handles.axLeftFFT,'xlim',[200 stSetup.Fs/2],'ylim',[0 100],'xscale','log','ytick',0:10:100);
semilogx(handles.axRightFFT,stSetup.f_Hz,Spec(:,1),'b-',...
                            stSetup.f_Hz,Spec(:,2),'r-');
mx = max(reshape(Spec(stSetup.f_Hz>400&stSetup.f_Hz<20000,:),[],1));
mn = min(reshape(Spec(stSetup.f_Hz>400&stSetup.f_Hz<20000,:),[],1));
if ~isnan(mx) && ~isinf(mx) && ~isnan(mn) && ~isinf(mn)
    set(handles.axRightFFT,'xlim',[200 stSetup.Fs/2],'ylim',[mn-15 mx+15],'xscale','log','ytick',0:3:100);
end
drawnow;
ITDix = get(handles.popITD,'Value');
ILDix = get(handles.popILD,'Value');



function FinishedCallback(stSetup)
handles = guidata(stSetup.hFigure);
handles.Setup = stSetup;
set(handles.txtOnlineInfo,'String',stSetup.Msg);
set(handles.tbnPlayRec,'Value',0);
guidata(stSetup.hFigure,handles);


function pbnSave_Callback(hObject, eventdata, handles)
[FileName,PathName] = uiputfile('*.fig','Save Figure');
if ischar(FileName) && ischar(PathName)
    set(handles.figOnlineABR,'MenuBar','figure','ToolBar','figure');
    hgsave(handles.figOnlineABR,fullfile(PathName,FileName));
    set(handles.figOnlineABR,'MenuBar','none','ToolBar','none');
    msgbox(sprintf('Figure saved to %s',fullfile(PathName,FileName)),'Saving successful','help','modal');
end


function popITD_Callback(hObject, eventdata, handles)



function popILD_Callback(hObject, eventdata, handles)


function tbnArtefacts_Callback(hObject, eventdata, handles)
stS = handles.Setup;
fs = stS.Fs;
Hw = stS.Hardware;
St = stS.Stimulus;
Rc = stS.Recording;
InputScalingFactor_uV = 10^(2/20)/1e4*2*sqrt(2)/1e-6;

%% sound device initialization
if playrec('isInitialised')
    playrec('reset')
end
playrec('init',fs,Hw.PlayDev,Hw.RecDev,Hw.PlayCh,Hw.RecCh,Hw.BufferSize);

hf = figure;
text(0,0,'Recording, please wait...');
xlim([-1 1]);
ylim([-1 1]);
pause(0.1);
drawnow;
page    = playrec('rec',round(5*fs),1:Hw.RecCh);
playrec('block',page);
rec = double(playrec('getRec',page)) * InputScalingFactor_uV;
plot((0:round(0.1*fs)-1)/fs,reshape(rec(:,Rc.EEGCh),round(0.1*fs),[]));
p = ginput(1);

answer = questdlg(sprintf('Set artefact threshold to %1.1f µV?',abs(p(2))),'Artefact threshold setup','Yes','No','No');

if strcmp(answer,'Yes')
    handles.Setup.Recording.ArtefactThr = abs(p(2)); % µV
    guidata(hObject,handles);
    DisplayInfo(handles);
end

close(hf);
set(hObject,'Value',0);
