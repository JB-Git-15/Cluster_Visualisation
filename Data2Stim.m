function Responses =  Data2Stim(DataFold,OutFold,Stim_Reordering_file_address, init_index)
 
  %%%   example : 
  %%%   DataFold = [ '~/Desktop/jacques/Data_analysis/Raw_data/',  '170821_col2/'];
  %%%   OutFold  = [ '~/Desktop/jacques/Data_analysis/Raw_data/',  '170821_col2/'];
  %%%   Stim_Reordering_file_address  : you can a matrix in which you put in the variable  Corresp, a 2* Number of stimulus array
  %%%   In the first row put the old index, in the second the new index :
  %%%   for example, we want the the stimulus blank to be ordered in the
  %%%   first place, when it used to be in the place 131. Therefore the
  %%%   first column of the Corresp table is: [131;1].
   
  %%% Do not use the variable Stim_Reordering_file_address if you don't need to permute the
  %%% order of the stims
  
  
  %%% Caution ! the mis-alignement between computer delivering the sounds and the microscope
  %%% recording the microscope imposes taking out 6 initital frames from
  %%% the recording.  If you need to do differently, create a file called
  %%% like this : 
  %%%  /170831_col6/170831_col6_params_alignement.mat
  %%% See line 59 of this function :  Data_corrected(init_index:end ...
  %%%      In this file, put two (scalar) variables : init_index and mdt
  %%% For instance, if you don't need any realignement: init_indiex = 1 et
  %%% mdt = 1
  
    
  if isunix || ismac
    slash = '/';
  elseif ispc
    slash = '\';
  end    
  
    addpath(['.',slash,'functions'])
    group = ''; 
 
 if length(OutFold)    
    if(~(OutFold(end)==slash)) 
	    OutFold(end+1)=slash; 
    end
 end
    group = ''; 
    
if ~exist([OutFold 'Data' group '.mat'])  
    
    temp         =  find(DataFold == slash);
    DataFold1    =  DataFold(temp(end)+1:end);
    
    load([DataFold,slash, 'ExperimentInfo.mat'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           Structnames      = dir(DataFold);
           N_to_test        = length(dir(DataFold));
           for uu = 1: N_to_test
               temp_name = Structnames(uu).name;
                if (length(temp_name) > 19)
                   if strcmp(temp_name(end-17:end),'mesc - regions.mat')
                       name_to_retain = temp_name;                                                                                  
                   end
                   
                   if strcmp(temp_name(end-17:end),'mesc - signals.mat')
                        name_to_retain2 = temp_name;
                   end
                end  
            end   
            load([DataFold,slash,name_to_retain])
            load([DataFold,slash,name_to_retain2])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   load([DataFold,slash, DataFold1 group '.mesc - signals.mat']);
%   load([DataFold,slash, DataFold1 group '.mesc - regions.mat']);

    NStimPerEp    = size(conds,1);
    Stims         = xpar.soundlist;
    Nstims        = length(Stims);
    StimDelay     = xpar.fix.StimDelay;
    TrialInterval = xpar.fix.TrialInterval;

    Data_corrected= signals -0.7*localneuropil;

         
      if exist([DataFold,slash,DataFold1,'_params_alignement.mat'])
   
                load([DataFold,slash,DataFold1,'_params_alignement.mat'])
                dt            =  dt*mdt; 
                Data_corrected=  Data_corrected(init_index:end,:,:);                
      else          

                 if nargin == 4
                      Data_corrected=  Data_corrected(init_index:end,:,:); 
                 else    
                      Data_corrected=  Data_corrected(7:end,:,:);            
                 end   
      end
      
      
      
 
Stimes         = ((0:NStimPerEp-1)*TrialInterval+StimDelay)/1000;
Sidx           = round(Stimes/dt);
Nbefore        = round(0.5/dt) ;   % 0.5 seconds before the stimulus
Nafter         = floor(1/dt);      % 1   s       after  


 
%%%%%%% \Delta F /F %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       

%%%%%    Baseline computation ...
disp 'Compute baseline in each block';

baseline          = fn_filt(Data_corrected,50,'lk',3);
baseline          = min(baseline,[],1);
Data_corrected    = Data_corrected ./repmat(baseline,[size(Data_corrected,1) 1 1 1])-1;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Initialize and agregate data
NEp            = size(conds,2);
Ncells         = size(Data_corrected,2);
NRep           = zeros(1,Nstims);
Traces         = zeros(Ncells, Nbefore+Nafter, Nstims, floor(NEp*NStimPerEp/Nstims));
if(min(size(conds))==1)
    conds=reshape(conds,[NStimPerEp NEp]);
end

%%%%%%    DP=TransientFitting(permute(data(:,:,1:2),[2 1 3]),dt,3);

fprintf('Assigning from block %03d',0);
for i=1:NEp
    fprintf('\b\b\b%03d',i);
    Cond=conds(:,i);
    
    for j=1:NStimPerEp
       NRep(Cond(j)) = NRep(Cond(j))+1;    
                  if(NRep(Cond(j))<=floor(NEp*NStimPerEp/Nstims))            
                        Traces(:,:,Cond(j), NRep(Cond(j)))=permute(Data_corrected(Sidx(j)+(-Nbefore:Nafter-1),:,i),[2 1 3]);
                  end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
if nargin >= 3            
  if length(Stim_Reordering_file_address)       
    load(Stim_Reordering_file_address);%('Definitive_corr.mat')
    Traces     = Traces(:,:,Corresp(1,:),:);
    Stims_temp = cell(size(Stims));
     for w = 1: size(Corresp,2)
           Stims_temp{1,w}  = Stims{Corresp(1,w)};
     end
           Stims            = Stims_temp;
 end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

fprintf('\n');


%TracesDN  = TracesD - repmat(mean(mean(TracesD(:,1:10,:,:),2),4),[1 n 1 q]);                         % align with spontaneous act

[m,n,p,q]  = size(Traces);
Calcium    = Traces - repmat( mean(Traces(:,1:10,:,:),2) ,[1 n 1 1]);                  
Calcium_av = mean(Calcium,4);



%Deconvolution and normalization

tau        =  2;  % s 
Traces_av_D= [diff(Calcium_av,1,2) zeros(m,1,p)]+[Calcium_av(:,1:end-1,:)  zeros(m,1,p)]*dt/tau;        % deconvolve

 
TracesDg  = gaussianfilter(Traces_av_D,1,1.2,1);   % p = 2 : 1.5


%TracesD   = [diff(Traces,1,2) zeros(m,1,p,q)]+[Traces(:,1:end-1,:,:)  zeros(m,1,p,q)]*dt/tau;          % deconvolve
%TracesDN  = TracesD -  repmat(mean(TracesD(:,1:10,:,:),2),[1 n 1 1]);                                  % align with spontaneous act
%repmat(mean(mean(TracesD(:,1:10,:,:),2),4),[1 n 1 q]);                                                 % align with spontaneous act
%TracesDN_av = mean(Traces,4); 
%%% Equation : dV/dt + V.dt/tau = firing
 


  Responses             = struct;
  Responses.Traces      = Traces;
  %Responses.TracesD     = TracesD;
  %Responses.TracesDN    = TracesDN;  
  Responses.Traces_av_D = Traces_av_D;
  Responses.TracesDg    = TracesDg;     % average over repetitions, deconvoluted, filtered
  Responses.dt          = dt;
  Responses.Nbefore     = Nbefore;
  Responses.Nafter      = Nafter;
  Responses.Stims       = Stims;  
  Responses.Calcium     = Calcium;
  Responses.Calcium_av  = Calcium_av;
 
    
  if length(OutFold)  
        if(exist(OutFold,'dir')~= 7)
            mkdir(OutFold); 
        end  
        if(~(OutFold(end)==slash)) 
            OutFold(end+1)=slash; 
        end 
        save([OutFold 'Data' group '.mat'],'Traces','dt','Nbefore','Nafter','Stims','Responses','-v7.3')
  end     
 
 else
   
        if length(OutFold) 
            load([OutFold 'Data' group '.mat'])
        end

 end
  
 
  
 
  
end
  
  
  



