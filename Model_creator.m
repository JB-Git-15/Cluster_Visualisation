


if length(All_data.data)&&length(All_info.data)

    hC                           = figure('Color','white','units', 'normalized','Position',[.1 0.1 .6 .4],'Name','Load and fit model' ,'MenuBar', 'none','ToolBar', 'none'); % ,'WindowStyle','modal');  

    All_Stims_choosen_to_fit     = Passage_par_ref(cell(1,size(All_info.data,2)));  
    All_Stims_choosen_to_test    = Passage_par_ref(cell(1,size(All_info.data,2)));  
    
    Stim1_add                    = All_data.data.Stims{1};
    [folder, baseFileName, ext]  = Give_file_parts(Stim1_add);

    text_stim_base               = uicontrol('style','text','string',folder,'units', 'normalized','position',[0.05 0.72 0.4 0.15],'BackgroundColor',[.9 .9 .9]);
    butt_change_base_add         = uicontrol('style', 'pushbutton','string', 'Change sound folder adress',...
                                             'units', 'normalized','position',[0.05 0.6 0.25 0.1],'callback',{@Change_base_sound_add,text_stim_base,All_data});
        
           butt_stims_to_fit                = uicontrol('style','pushbutton','string', 'Stims to fit','units', 'normalized','position',[0.25 0.2 0.15 0.1], ...
                                                           'callback',{@Choose_stims_to_fit,All_info, All_Stims_choosen_to_fit},'BackgroundColor',[0 .8 0]);
                                                       
           butt_stims_to_test                = uicontrol('style','pushbutton','string', 'Stims to test','units', 'normalized','position',[0.42 0.2 0.15 0.1], ...
                                                           'callback',{@Choose_stims_to_test, All_info, All_Stims_choosen_to_fit, All_Stims_choosen_to_test});  
         
           liste_models_to_fit              = uicontrol('style','listbox','string', '', 'units', 'normalized','position',[0.5 0.45 0.45 0.35]); 
         
           butt_load_models                 = uicontrol('style','pushbutton','string', 'Choose models','units', 'normalized','position',[0.6 0.84 0.16 0.1], ...
                                                           'callback',{@Choose_function, liste_models_to_fit});
           butt_model_and_fit               = uicontrol('style','pushbutton','string', 'Fit',...
                                             'units', 'normalized','position',[0.8 0.84 0.1 0.1],'callback',{@Fit, All_info, All_data, liste_models_to_fit, All_models, list_mod, All_Stims_choosen_to_fit, All_Stims_choosen_to_test});                                     
                                     
           butt_close                       = uicontrol('style','pushbutton','string', 'Close','units', 'normalized','position',[0.8 0.2 0.1 0.1],'callback',{@Close_wind, hC});                             
                                         

else                                     
         msgbox('Charge first the visualisation parameters and the data ! ');                                                                                      
end                  
                                        
                                     
function Change_base_sound_add(object_handle, event, text_stim_base,All_data)

  Stim1_add                        = All_data.data.Stims{1};
[former_add, baseFileName, ext]    = Give_file_parts(Stim1_add);

  if isunix || ismac
        slash = '/';
  elseif ispc
        slash = '\';
  end  
   answer      = questdlg('Change the stimulus address ?','', 'Yes','No','Yes');
   switch answer
       case 'Yes'
            folder_name = uigetdir;
                if ischar(folder_name)
                    set(text_stim_base,'String',folder_name);
                    
                       answer1      = questdlg('Set this address in the data file ?',' ', 'Yes','No','No');
                              switch answer1
                              case 'Yes'
                                      for uu = 1:length(All_data.data.Stims)      
                                             temp_file_name                     =  All_data.data.Stims{uu};
                                             [former_add, baseFileName, ext]    =  Give_file_parts(temp_file_name);
                                            
                                             All_data.data.Stims{uu}            =  [folder_name,slash,baseFileName];
                                      end
                              case 'No' 
                              end        
                 end
       case 'No'
   end 
end
                                     



 function [folder, baseFileName, ext]  = Give_file_parts(filename)
     % Basefile name contains the extension
     % The original file might have been recorded in a win or in a pc         
       Is_win   =   length(find( filename  == '\' ));    
       Is_ux_mc =   length(find( filename  == '/' ));     
              ok = 1;
              if Is_win
                     slash = '\';
              elseif Is_ux_mc
                     slash = '/';             
              else
                ok = 0;  
              end
             if ok 
                     Indexes   = find(filename == slash);
                     Index_ext = find(filename == '.'); 
                     if length(Indexes) 
                             baseFileName = filename(Indexes(end)+1: end);    
                             ext          = filename(Index_ext:end);

                                 if length(Indexes) >= 2    
                                        if (Indexes(end -1) == (Indexes(end) -1)) % // si double barre    
                                             folder  = filename(1:Indexes(end -1));    
                                        else
                                             folder  = filename(1:Indexes(end));  
                                        end
                                 end
                     else
                                   folder       = '';
                                   baseFileName = '';
                                   ext          = '';
                                   disp('no file in input !')
                     end    
             else
                                   folder       = '';
                                   baseFileName = '';
                                   ext          = '';
                                   disp('no file in input !') 
             end
 end
                                     
 function Choose_function(event, object_handle, liste_models_to_fit)
[filename, pathname] =  uigetfile({'*.m'},'Choose a function to fit the data','MultiSelect', 'on');
      if length(pathname)
           if ~ischar(filename)
                for uuu = 1: length(filename)
                    filename{uuu} = [pathname,filename{uuu}];
                end  
           else     
                    filename      = [pathname,filename];
           end     
                    set(liste_models_to_fit,'String',filename);
                    set(liste_models_to_fit,'Value',1);
      end
 end 
                                     
 function  Fit(event, object_handle, All_info, All_data, liste_models_to_fit, All_models, list_mod, All_Stims_choosen_to_fit, All_Stims_choosen_to_test)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%  Gets the function path
 %%%  Find the indexes of the data and stim
 %%%  Load the stimuli
 %%%  Subset of data/clusters ? 
 %%%  Load the data
 %%%  Fit  the data
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Function path
      LST = get(liste_models_to_fit,'String'); 
      Val = get(liste_models_to_fit,'Value');
      
     if ischar(LST)|| iscell(LST)    
         if ischar(LST)
            Model_path = LST;
         else       
            Model_path = LST{Val}; 
         end
         
          [folder, name_funct, ~]     = Give_file_parts(Model_path);
if ~strcmp(folder,'')          
          
                              addpath(genpath(folder));          %%% This allows to call the functions that are called by the function used
                                                                 %%% which are supposed to be subfolder or in the same folder as the pointed function         
                      %%%% V1 : Stims to fit    
                               Concatenated_Ind_stims_to_fit = [];  
                               for ww = 1 :size(All_info.data,2)
                                           Index_chosen_stims                   =  find(All_Stims_choosen_to_fit.data{1,ww} == 2);
                                           if length(Index_chosen_stims)
                                                Index_Fam                       = All_info.data(ww).Index;
                                                Concatenated_Ind_stims_to_fit   = [Concatenated_Ind_stims_to_fit; Index_Fam(Index_chosen_stims)];
                                           end
                               end                            
                       %%%% V1: Stims to test
                                Concatenated_Ind_stims_to_test = [];  
                               for ww = 1 :size(All_info.data,2)
                                           Index_chosen_stims                    = find(All_Stims_choosen_to_test.data{1,ww} == 2);
                                           if length(Index_chosen_stims)
                                                Index_Fam                        = All_info.data(ww).Index;
                                                Concatenated_Ind_stims_to_test   = [Concatenated_Ind_stims_to_test; Index_Fam(Index_chosen_stims)];
                                           end
                               end   
                        if length(Concatenated_Ind_stims_to_fit)        

                               Concatenated_stims_to_fit      = [];
                               Concatenated_stims_to_test     = [];
                               Concatenated_freq_fit          = []; 
                               Concatenated_freq_test         = [];

                                          for abc = 1: length(Concatenated_Ind_stims_to_fit)
                                                 stim_add                         = All_data.data.Stims{Concatenated_Ind_stims_to_fit(abc)};  
                                                 [stm_temp,Fs]                    = audioread(stim_add); 
                                                        temp                      = cell(1,1);
                                                        temp{1,1}                 = stm_temp;  
                                                 Concatenated_stims_to_fit        = [Concatenated_stims_to_fit; temp]; 
                                                 Concatenated_freq_fit            = [Concatenated_freq_fit;Fs];
                                          end   

                                          for efg = 1: length(Concatenated_Ind_stims_to_test)
                                                 stim_add                         = All_data.data.Stims{Concatenated_Ind_stims_to_test(efg)};  
                                                 [stm_temp,Fs]                    = audioread(stim_add); 
                                                        temp                      = cell(1,1);
                                                        temp{1,1}                 = stm_temp;  
                                                 Concatenated_stims_to_test       = [Concatenated_stims_to_test; temp]; 
                                                 Concatenated_freq_test           = [Concatenated_freq_test;Fs];
                                          end   

                        %%%% Subset of clusters ? 
                                       choice = questdlg('Select a subset of clusters ?', '', ...
                        'Yes, select a list','Yes, select manually','No, select all','No, select all');
                                     switch choice
                                        case 'Yes, select a list'
                                             option = 1;
                                        case 'Yes, select manually'
                                             option = 2;
                                        case 'No, select all'
                                             option = 0;
                                     end    
                                        if option == 1
                                                num_list =  size(All_data.data.Lists,1);
                                                temp     =  cell(1,size(All_data.data.Lists,1));
                                                for   u = 1: size(All_data.data.Lists,1)
                                                     temp{1,u} = All_data.data.Lists{u,1};
                                                end    
                                                [s,v] = listdlg('PromptString','Select a list:',...
                                                        'SelectionMode','single',...
                                                        'ListString',temp);
                                                if v % une selection est faite    
                                                     Liste_clusters = All_data.data.Lists{s,2}';
                                                else
                                                     Liste_clusters = All_data.data.Lists{1,2}'; % tous les clusters (liste default)
                                                end
                                        elseif option == 2        
                                                         N_max          = size(All_data.data.Resp,1); 
                                                         ok             = 0; 
                                                         Liste_clusters = [];
                                                         while (ok == 0)        
                                                             prompt     = {['Cluster number between: 1  and ', num2str(N_max)]};
                                                             dlg_title  = 'Input';
                                                             num_lines  = 1;
                                                             defaultans = {''};
                                                             answer     = inputdlg(prompt,dlg_title,num_lines,defaultans);

                                                            if length(answer) 
                                                               if isnumeric(str2num(answer{1}))
                                                                 if (str2num(answer{1})  >= 1) &&(str2num(answer{1})  <= N_max)
                                                                        Liste_clusters = [ Liste_clusters; str2num(answer{1})];
                                                                 else
                                                                        msgbox(['Number not comprised between: 1  and ', num2str(N_max)])
                                                                 end    
                                                               end  
                                                            else
                                                                if length(Liste_clusters) >= 1
                                                                    ok = 1; 
                                                                end 
                                                            end 
                                                           end 
                                        else
                                                  Liste_clusters = All_data.data.Lists{1,2}'; % tous les clusters (liste default)
                                        end    
                             %%%%  Load the data
                                  %%%%%%  V1 :      
                                        Data_to_fit              =  All_data.data.Resp(Liste_clusters,:,Concatenated_Ind_stims_to_fit);
                                        Data_to_test             =  All_data.data.Resp(Liste_clusters,:,Concatenated_Ind_stims_to_test);

                                        T_stim                   =  All_info.data(1).t_bef_stim;  % time at which the stimulus arrives...
                                        dt                       =  All_data.data.dt;             % data time chopping


                              %%%%  Fit the data :  Inputs :  Data_to_fit, Concatenated_stim, Concatenated_freq  , ( parameters )         
                             %%%%                  Outputs:  Model (same dimension as Data_to_fit) , Parameters (optimal set)           
                                    % function_name   
                                        name_funct            = name_funct(1:end-2);
                                        eval(['[Model, Parameters] = ', name_funct,'(Data_to_fit, Data_to_test, T_stim , dt, Concatenated_stims_to_fit, Concatenated_stims_to_test, Concatenated_freq_fit, Concatenated_freq_test);']);

                                        okk = 0;
                                        while okk == 0 
                                             prompt       = {'Enter model name'};
                                             dlg_title    = '';
                                             num_lines    = 1;
                                             defaultans   = {''};
                                             answer       = inputdlg(prompt,dlg_title,num_lines,defaultans);
                                            if length(answer)
                                                okk       = 1;
                                            end    
                                       end
                                        dir_funct             = [folder, name_funct ,'.m'];
                                        temp                  = struct;
                                        temp.name             = answer{1,1};
                                        temp.Parameters       = Parameters;
                                        temp.Name_model       = dir_funct;
                                        temp.Ind_stims        = Concatenated_Ind_stims_to_test; 
                                        temp.Liste_clusters   = Liste_clusters;
                                        temp.Data_fit         = Model;
                                        All_models.data       = [All_models.data; temp];      
                                        Liste                 = get(list_mod,'String');


                                        if ischar(Liste)
                                           Liste_temp         = cell(1,1);
                                           Liste_temp{1,1}    = Liste;
                                        else 
                                           Liste_temp         = Liste; 
                                        end    
                                        Liste_temp{end+1,1}   = answer{1,1};
                                        set(list_mod,'String', Liste_temp);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                        else   
                          msgbox('First choose the stims you want to fit !')      
                        end
                     else   
                          msgbox('Load first the functions !')      
        end
                  
     end      
 end
 function Close_wind(event, object_handle, hC)
          close(hC);
 end
 
 function Choose_stims_to_fit(event, object_handle,All_info,All_Stims_choosen_to_fit)
          Stims_to_fit_choose;
 end
 
function Choose_stims_to_test(event, object_handle,All_info,All_Stims_choosen_to_fit, All_Stims_choosen_to_test)
      if  ~prod(cellfun(@isempty, All_Stims_choosen_to_fit.data)) 
           Stims_to_test_choose;
      else
           msgbox('First choose the stims to fit !')
      end  
 end
                                      
                                     