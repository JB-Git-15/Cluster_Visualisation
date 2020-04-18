close all
clear all
clc

addpath('./functions/')

dimS           = get(0,'ScreenSize');  
hFig           = figure('Color','white','position',dimS,'Name','Data preprocessing');
 
%ButtonH        = uicontrol('Parent',hFig,'Style','pushbutton','String','File','Units','normalized','Position',[0.0 0.95 0.05 0.05],'Units','normalized','Visible','on');
%NameFile       = uicontrol('Parent',hFig,'Style','text','String','','Position',[0.06 0.95 0.1 0.05],'Units','normalized','Visible','on');


%hObject.NameFile = NameFile;
%  txt = uicontrol('Style','text',...
%        'Position',[400 45 120 20],...
%        'String','Vertical Exaggeration');

%handles.edit = uicontrol('style','edit',...
%   'callback',{@my_callback}); %create editbox

% txt2 = uicontrol('Style','text',...
       % 'Position',[400 45 120 20],...
      %  'String',' ');

 %set(ButtonH,'Callback', @Get_file);

[file,path] = uigetfile('*.mat');


 
 %%%%%%%%%%%%%% A piece of code to read the files
  
  
    
% if(~(OutFold(end)=='/')) 
%     OutFold(end+1)='/'; 
% end
  %  group = ''; 
    
  
  
if ((exist( [path file 'Data' '.mat']  ) == 0  ))
    
    temp         =  find(path == '/');
    DataFold1    =  path(temp(end)+1:end);
    
    load([path,'/', 'ExperimentInfo.mat'])
    load([path,'/', savename  ' - signals.mat']);
    load([path,'/', savename  ' - regions.mat']);

    NStimPerEp    = size(conds,1);
    Stims         = xpar.soundlist;
    Nstims        = length(Stims);
    StimDelay     = xpar.fix.StimDelay;
    TrialInterval = xpar.fix.TrialInterval;

    Data_corrected= signals -0.7*localneuropil;   % neuro pil correction

    baseline      = fn_filt(Data_corrected,50,'lk',3);
    
    
end   
    
    
    
    
    
    
    
         
%       if exist([DataFold,'/',DataFold1,'_params_alignement.mat'])
%    
%                 load([DataFold,'/',DataFold1,'_params_alignement.mat'])
%                 dt            =  dt*mdt; 
%                 Data_corrected=  Data_corrected(init_index:end,:,:);                
%       else          
%                 Data_corrected=  Data_corrected(7:end,:,:);            
%       end
      
      
      
 
% Stimes         = ((0:NStimPerEp-1)*TrialInterval+StimDelay)/1000;
% Sidx           = round(Stimes/dt);
% Nbefore        = round(0.5/dt) ;   % 0.5 seconds before the stimulus
% Nafter         = floor(1/dt);      % 1   s       after  


 
%%%%%%% \Delta F /F %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       

%%%%%    Baseline computation ...
disp 'Compute baseline in each block';

baseline          = fn_filt(Data_corrected,50,'lk',3);
baseline          = min(baseline,[],1);
Data_corrected    = Data_corrected ./repmat(baseline,[size(Data_corrected,1) 1 1 1])-1;
 
 
 
 
 
 %%%%%%%%%%%%%
 
 
 
 
 
 
 
 

    [ left   bottom  width  height] = Dimensionate_frame(zeros(4,2),1,1);
    a1 = axes('position',[ left   bottom  width*.9  height]);
       plot(1:10)
       title('Raw population calcium trace')
            
            
   [ left   bottom  width  height] = Dimensionate_frame(zeros(4,2),1,2);
    a2 = axes('position',[ left   bottom  width*.9  height]);
       plot(1:10)
       title('Filtered population calcium trace')
                    
            
            


function [file,path] =  Get_file(hObject,event)
fprintf('Hello world');

[file,path] = uigetfile('*.mat');
%set(txt,'String',path)

%fprintf(file);
 
end

