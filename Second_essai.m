clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Choice of display settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%     Load or create a new way of display the responses
%%%%
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



choice = questdlg('',... 
'                      Choice of display settings','Load file with display settings','Create new stimulus set','Create new stimulus set');

Open_wind = 0;  
All_info  = Passage_par_ref([]); % every new stimuls category is going to be in a cell, that is going to contain a struct with all the relevant information (name, x,y axis, indices, times)

switch choice
    case 'Load file with display settings'
             filename = uigetfile;   
             load(filename)
              
    case 'Create new stimulus set'
             disp('Create a new stimulus set')  
             Open_wind = 1;
end
                  
 if Open_wind
        dimS      = get(0,'ScreenSize');  
        h1 = figure('Color','white','Position',dimS,'Name','Stimulus types','MenuBar', 'none','ToolBar', 'none');   
     
        
        
               stim_Max_l    = uicontrol('Style','text','units', 'normalized','position', [0.27 0.3 0.2 0.05],'String',' ');  

               yourcell      =  {}; % {'mass','velocity','time','acceleration','speed'};
               liste         = uicontrol('Style', 'listbox','units', 'normalized','position', [0.6 0.3 0.3 0.6],'string',yourcell,'Callback',{@Explore_or_delete,All_info,stim_Max_l});
          
               but_new_type  = uicontrol('style', 'pushbutton','string', 'New class of stimuli',...
                                         'units', 'normalized','position', [0.05 0.9 0.2 0.05],'callback',{@Create_New_Class,All_info,liste,stim_Max_l});%
                                     
                %but_erase_cla = uicontrol('style', 'pushbutton','string', 'Erase class',...
               %                          'units', 'normalized','position', [0.05 0.75 0.2 0.05]);%
                               
               texte1        = uicontrol('Style','text','units', 'normalized','position', [0.05 0.6 0.2 0.05],...
        'String','Time before stimulus (s)');
        
               texte2        = uicontrol('Style','text','units', 'normalized','position', [0.05 0.45 0.2 0.05],...
        'String','Time after stimulus end (s)');   
    
               texte3        = uicontrol('Style','text','units', 'normalized','position', [0.05 0.3 0.2 0.05],...
        'String','Stimulus maximal lenght (s)');  
    
               t_bef_stim    = uicontrol('style','edit','string','0.5','Units','normalized','Position',[0.27 0.6 0.2 0.05]);
               
               t_aft_stim    = uicontrol('style','edit','string','0.5','Units','normalized','Position',[0.27 0.45 0.2 0.05]);
               
               but_validate  = uicontrol('style', 'pushbutton','string', 'Save and close',...
                                         'units', 'normalized','position', [0.8 0.2  0.1 0.05],'callback',{@Save_and_close, All_info, t_bef_stim, t_aft_stim, stim_Max_l, h1},'backgroundColor','green');%
             
              but_fuse_stims = uicontrol('style', 'pushbutton','string', 'Stimuli to visualize together',...
                                         'units', 'normalized','position', [0.6 0.2  0.18 0.05],'callback',{@Fuse_stims, All_info});%                     
                                     
                                     
 end                                                                                                                                     
 
 
 
 
 function Create_New_Class(object_handle, event,All_info,liste,stim_Max_l)
 
          New_class_of_stim;
  
 end
 
 
 function Explore_or_delete(object_handle, event,All_info,stim_Max_l)
        if strcmp(get(gcf,'SelectionType'),'open')
            
            
                items = get(object_handle,'String');
      index_selected = get(object_handle,'Value');
       item_selected = items{index_selected};
        display(item_selected);
           
           
        resp = questdlg('Do you want to delete or to explore this stimulus set','','Delete','Explore','Explore');
        switch resp
            case 'Delete'
                 
               choice = questdlg('Confirm that you want to delete?', '', 'Yes, delete','No','No');

                    switch choice
                        case 'Yes, delete'
                        
                            
                                All_info.data(index_selected)= [];   % Delete ! 
                            
                                %%%%%%%%%%%%%%%%%%%% Update main figure
                                    n_stims         = size(All_info.data,2);
                                    text            = cell(1,n_stims);
                                    Max_stim_length = -1;

                                    
                                    if n_stims
                                       for ux = 1: n_stims
                                         temp_struct      = All_info.data(1,ux);  
                                         text{1,ux}       = temp_struct.name;
                                         Max_stim_length  = max(Max_stim_length,max(max(temp_struct.Stim_len)));
                                       end
                                    end

                                     set(object_handle,'String',text);  % update the listbox
 
                                     set(stim_Max_l,'String',num2str(Max_stim_length)); % update the value of the maximal stimulus length
                                     
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
                            
                    end
                
              case 'Explore'
               %  display(All_info.data(1,index_selected).name)
                                display(['name: ', All_info.data(1,index_selected).name])
                                
                                n_y = size(All_info.data(1,index_selected).Index,1);
                                n_x = size(All_info.data(1,index_selected).Index,2);
                                
                                display(['y labels'])
                                for ui= 1: n_y
                                    display(All_info.data(1,index_selected).ylabs{1,ui});
                                end
                                    
                                 display(['x labels'])
                                for ui= 1: n_x
                                    display(All_info.data(1,index_selected).xlabs{1,ui});
                                end
                                
                            
                                display(['Indices: ']), display(All_info.data(1,index_selected).Index)
                                
                                display(['Stimulus lengths:  ']), display(All_info.data(1,index_selected).Stim_len)
        end
         end    
 end
 
 
 function  Save_and_close(object_handle, event, All_info, t_bef_stim, t_aft_stim, stim_Max_l, h1)
 
            [filename,path] = uiputfile;   

            if  filename  == 0
                  msgbox('please enter a valid path')
            else    
                
                time_bef_stim = str2double(t_bef_stim.String);
                time_aft_stim = str2double(t_aft_stim.String);
                Max_time_stim = str2double(stim_Max_l.String);
                
                Struc = ObjToStruct(All_info, [path,filename]);
                save([path,filename], 'Struc', 'time_bef_stim', 'time_aft_stim','Max_time_stim')
                
                close(h1)
            end    
 
 end
 
 
 
 
 function Fuse_stims(object_handle, event, All_info)
 
    Display_what_to_fuse;
 
 end
 
 
 
 
 
 function Struc = ObjToStruct(obj, filename)

              varname = inputname(1);

              props = properties(obj);

              for p = 1:numel(props)

                  s.(props{p})=obj.(props{p});

              end

              %eval([varname ' = s'])

              %save(filename, varname)
         Struc = s;
              
 end
 
 
 
 
 
 