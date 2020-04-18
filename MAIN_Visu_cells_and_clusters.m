%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualize single cells and clusters%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% last update: 31/01/2019


        dimS      = get(0,'ScreenSize');  
        hC        = figure('Color','white','units', 'normalized','Position',[.1 0 .16 1],'Name','Visualisation','MenuBar', 'none','ToolBar', 'none');   
     
                    ws               = evalin('base','whos');
                    ALL_info_present = length(find( strcmp({ws.name}, 'All_info')));
                    
                if ALL_info_present
                    Strng = 'Visu parameters loaded !';
                else
                    Strng = '';
                    All_info  = Passage_par_ref([]);  % This applies to the case in which we initialise directly thee script "Visu_cells_and_clusters", withouth passing 
                                                      % by the precedent steps 
                end
                    
        edit_pars         = uicontrol('Style','text','units', 'normalized','position', [0.1 0.9 0.8 0.04],'String',Strng);
   
       %%%%%%%%%%%%   First be sure of having the visualisation parameters
       %%%%%%%%%%%%   before everithing.... 
        
    butt_Load_pars                       = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.95 0.8 0.04],'String','Load visualisation parameters ','callback',{@Load_Pars, All_info, edit_pars});  
    All_data                             = Passage_par_ref([]);        
    All_models                           = Passage_par_ref([]);
    All_models.data                      = [All_models.data; struct];  
    All_models.data(end).name            = 'no model';
    All_models.data(end).Parameters      = [];
    All_models.data(end).Name_model      = '';
    All_models.data(end).Ind_stims       = [];
    All_models.data(end).Liste_clusters  = [];
    All_models.data(end).Data_fit        = [];
     
       %%%%%%%%%%%%%%   Load raw data/ Load already clustered data
        
       exact_dir_dat= Passage_par_ref(''); 
       dir_rawdat   = uicontrol('Style','text','units', 'normalized','position', [0.1 0.8 0.8 0.04],'String','');
       list_Annots  = uicontrol('Style','popup','units','normalized','position',[0.1  0.43 0.3 0.06],'String',{'default'},'value',1);
       butt_rawdat  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.845 0.8 0.04],'String','Load data','callback',{@Load_Data,All_data,dir_rawdat,list_Annots});
  
       %%%%%%%%%%%%%   Load models
       list_mod       = uicontrol('Style','popup','units','normalized','position',[.1 (.18) 0.38 0.04],'String', All_models.data(1).name,'value',1);
       txt_models_Add = uicontrol('Style','text','units', 'normalized','position', [0.1 0.7 0.8 0.04],'String','');
       butt_load_mod  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.741 0.8 0.04],'String','Load models','callback',{@Load_Models,txt_models_Add,All_models,list_mod});
 
       %%%%%%%%%%%%%% Plot all the data... 
       %%%%%%%%%%%%% Cluster counter and 
       Clu_count    = Passage_par_ref(0);
       Range_plots  = Passage_par_ref(0);
       
       hand_plots   = Passage_par_ref([]);
        
       txt_count_clu= uicontrol('Style','text','units', 'normalized','position', [0.6 0.45 0.2 0.04],'String','');
       txt_min_clu  = uicontrol('Style','text','units', 'normalized','position', [0.44  0.5 0.05 0.04],'String','');
       txt_max_clu  = uicontrol('Style','text','units', 'normalized','position', [0.72  0.5 0.15 0.04],'String','');

       txt_act_numC = uicontrol('Style','text','units','normalized','position',[0.44  0.40 0.15 0.04],'String','');
       check_square = uicontrol('style','checkbox','units','normalized','position',[.83,.645,.06,.05],'string','','BackgroundColor',[1 1 1],'Value',0);
       butt_plot    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.62 0.8 0.04],'String','Plot data','callback',{@Plot_Data, All_data, All_info, hand_plots, Clu_count, txt_count_clu,txt_min_clu,txt_max_clu, Range_plots,check_square,txt_act_numC, list_mod, All_models});
 
       butt_left    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.5  0.5 0.1 0.04],'String','<-','callback',{@Prev, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models});
       butt_right   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.61 0.5 0.1 0.04],'String','->','callback',{@Next, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models});
                           
       btt_annotate = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 (0.25+.05) 0.4 0.04],'String','Annotate','callback',{@Annotate, All_data,Clu_count,hand_plots,All_info});
       btt_creat_lst= uicontrol('Style','pushbutton','units', 'normalized','position',[.1  (.2+.05) 0.45 0.04],'String','Create list','callback',{@Visu_List,All_data,list_Annots});
       btt_erase_lst= uicontrol('Style','pushbutton','units', 'normalized','position',[.57 (.2+.05) 0.38 0.04],'String','Erase list','callback',{@Erase_List,All_data,list_Annots});

       btt_sav_annt = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 (0.06) 0.85 0.04],'String','Save annotations & lists','callback',{@Save_Annot, All_data});
       btt_clos_plt = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.01 0.85 0.04],'String','Close Plots','callback',{@Close_Plots, hand_plots, Clu_count, txt_count_clu,txt_min_clu,txt_max_clu});
       
       txt_zoom     = uicontrol('Style','text','units', 'normalized','position', [(0.1 +.3) 0.35 0.3 0.04],'String','Zoom y');
       btt_plus_rg  = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.41+.3) 0.35 0.1 0.04],'String','+','callback',{@Plus_range,  All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});       
       btt_min_rg   = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.52+.3) 0.35 0.1 0.04],'String','-','callback',{@Minus_range, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});
     
       btt_model_c  = uicontrol('Style','pushbutton','units', 'normalized','position', [.57 (.18) 0.38 0.04],'String','Model Create','callback',{@Model_create, All_data, All_info, list_mod, All_models});
       btt_sav_mod  = uicontrol('Style','pushbutton','units', 'normalized','position', [.57 (.13) 0.38 0.04],'String','Model Save','callback',{@Model_save, All_data, All_models});
       %btt_ref_mod  = uicontrol('Style','pushbutton','units', 'normalized','position', [.1 (.13) 0.38 0.04],'String','Model Refit','callback',{@Refit, All_data, All_info, list_mod, All_models});
       
       ed_set_clu_n = uicontrol('Style','edit','units','normalized','position',[0.44  0.45 0.1 0.04],'String','','callback',{@Set_cluster_num, All_data, All_info, hand_plots, Clu_count, txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,list_Annots,txt_act_numC,list_mod,All_models});

       txt_num_cell = uicontrol('Style','text','units','normalized','position',[0.18  0.40 0.22 0.04],'String','# cells');

       butt_print   = uicontrol('Style','pushbutton','units', 'normalized','position',[0.1 -4.43 0.3 0.04],'String','Print','callback',{@Print,All_info, hand_plots, Clu_count});
      
       butt_Mod_ev  = uicontrol('Style','pushbutton','units', 'normalized','position',[.1 (.13) 0.38 0.04],'String','Eval model','callback',{@Eval_mod,All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models});
         
       
         function Load_Pars(object_handle, event, All_info, edit_pars)
            filename = 0;
              while (filename == 0)
                       [filename,path] = uigetfile;   
                   if  filename  == 0
                        msgbox('please enter a valid path')
                   else   
                        [folder, baseFileName, extension] = fileparts([path,filename]);
                       if strcmp(extension,'.mat')
                          load([path,filename]);
                            if exist('Struc')
                               All_info.data = Struc.data;
                               set(edit_pars,'String',filename); 
                            else
                               msgbox('This file is not the good one !') 
                             end
                       else
                               msgbox('The selected file has not the right extension')       
                       end
                   end 
              end 
        end
        
        function Load_Data(object_handle, event,All_data,dir_rawdat,list_Annots)
              if isunix || ismac
                slash = '/';
              elseif ispc
                slash = '\';
              end   
                     ok      = 1;
                     List    = {};
                     count   = 1; 
                     choice0 ='';
               while strcmp(choice0,'')
                     choice0 = questdlg('Choose file by file or get a  previous list of data ?', 'Files', 'File','List of experiments','List of experiments');               
                         switch choice0
                             case 'File'              
                                     while ok == 1
                                        choice = questdlg('Choose a file ?', 'List of files', 'Yes','Stop','Stop');
                                                switch choice
                                                    case 'Yes'
                                                           folder_name = uigetdir;
                                                           index       = find(folder_name == slash);
                                                           file        = folder_name(index(end) +1:end);
                                                           List{count} = folder_name;
                                                           count       = count + 1;    
                                                           disp(folder_name)
                                                     case 'Stop'
                                                        ok = 0;
                                                        disp('List complete')
                                                end
                                     end
                             case 'List of experiments'
                                                        filename = '';
                                                        while strcmp(filename,'')
                                                           [filename, pathname] = uigetfile({'*.mat'},'File Selector');
                                                        end
                                                           load([pathname,filename])
                             end  
               end      
       %%%%%%%%%%%%%%%%% Until here,  we stock in List the address of the files to visualize
       %%%%%%%%%%%%%%%%% Now we load and we stock it in All_info
                                                  Resp = [];
                                                  for uu = 1:length(List) 
                                                       folder_name   = List{uu};
                                                             if exist([folder_name,slash,'Data.mat'])
                                                                    load([folder_name,slash,'Data.mat'])
                                                                    if ~exist('Responses')
                                                                     if exist('TracesDg')
                                                                            Responses          = struct;
                                                                            Responses.TracesDg = TracesDg;
                                                                     end
                                                                     if exist('dt')
                                                                            Responses.dt       = dt;
                                                                     end    
                                                                  end    
                                                             else        % This is to obverve one expermient at a time: in this case we will observe individual cells 
                                                                     %%%%% Get the Reordering file adress 
                                                                                 [filename, pathname] = uigetfile({'*.mat'},'Reordering stims file address');
                                                                                 if length(filename) 
                                                                                   Stim_Reordering_file_address = [pathname,filename];
                                                                                 end  
                                                                     %%%%% Get the index for the realignement: Cortex 5, IC: 7
                                                                     init_index               =  7;  
                                                                     prompt   = {''};
                                                                     title    = 'Offset recording: (ex: 7 colliculus, 5 cortex)';
                                                                     dims     = [1 35];
                                                                     definput = {'7'};
                                                                     answer   = inputdlg(prompt,title,dims,definput);
                                                                     if length(answer)
                                                                        init_index =  str2num(answer{1,1});
                                                                     else
                                                                         init_index = 7;
                                                                     end    
                                                                     %%%%% 
                                                                     if length(Stim_Reordering_file_address)
                                                                        Responses                =  Data2Stim(folder_name,'',Stim_Reordering_file_address, init_index);
                                                                     else
                                                                        Responses                =  Data2Stim(folder_name,'','', init_index);
                                                                     end
                                                             end
                                                                     Resp                     =  cat(1,Resp,Responses.TracesDg);   
                                                  end
                                                                     All_data.data                    = struct;
                                                                     All_data.data.Resp               = Resp;    % Assign all the data to the     
                                                                     All_data.data.dt                 = Responses.dt;
                                                                     
                                                                     if ~exist('Annotations')
                                                                         All_data.data.Cats_Annotation    = cell(1,1);
                                                                         All_data.data.SubCats_Annotation = cell(1,1);
                                                                         All_data.data.Annotations        = cell(size(Resp,1),1);
                                                                         All_data.data.Lists              = cell(1,2);
                                                                         All_data.data.Lists{1,1}         = 'default';
                                                                         All_data.data.Lists{1,2}         = 1:size(Resp,1);
                                                                     else
                                                                         All_data.data.Cats_Annotation    = Cats_Annotation;
                                                                         All_data.data.SubCats_Annotation = SubCats_Annotation;
                                                                         All_data.data.Annotations        = Annotations;
                                                                         All_data.data.Lists              = Lists;
                                                                     end    
                                                                     
                                                                     if ~exist('List_Raw_files')
                                                                          All_data.data.List_Raw_files =  [];
                                                                     else
                                                                          All_data.data.List_Raw_files =  List_Raw_files;
                                                                     end
                                                                     
                                                                     if ~exist('Liste_cells_cluster')
                                                                          All_data.data.Liste_cells_cluster =  [];
                                                                     else
                                                                          All_data.data.Liste_cells_cluster =  Liste_cells_cluster;
                                                                     end
                                                                     
                                                                     if ~exist('Buffer_labels')
                                                                          All_data.data.Buffer_labels =  [];
                                                                     else
                                                                          All_data.data.Buffer_labels =  Buffer_labels;
                                                                     end
                                                                     
                                                                     if ~exist('Stims')
                                                                         All_data.data.Stims = [];
                                                                     else    
                                                                         All_data.data.Stims = Stims;
                                                                     end
                                                                     set(dir_rawdat,'String','Data loaded ! ')
                                                                     set(list_Annots,'String',(All_data.data.Lists(1:end,1))');
                                                                     
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                        
             % Verifie si Spatial info existe et si on peut le créer 
                                                                    if size(All_data.data.Buffer_labels,1)
                                                                           if size(All_data.data.Buffer_labels,2) ==4 % if there are only 4 columns we can try to extend it by adding two more columns x and y    
                                                                                   Buff_temp_cord = [];
                                                                                       for n_list = 1:size(All_data.data.List_Raw_files,2)

                                                                                               folder_add_file  =  All_data.data.List_Raw_files{n_list};   

                                                                                               %ind_slash        =  find(slash == folder_add_file);
                                                                                               %name_folder      =  folder_add_file(ind_slash(end) + 1: end);
                                                                                               %name_folder      =  [name_folder,'.mesc - regions.mat'];

                                                                                               %%% which cells to look for 
                                                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Buffer labels : 4 cols :     # of mice | index file in list of files |  Depth (µm)  |  cell # in recording  
                                                                                               indices_act_file                  = find(All_data.data.Buffer_labels(:,2) == n_list);
                                                                                               cell_num_to_look_in_current_file  = All_data.data.Buffer_labels(indices_act_file,4);
                                                                                               %%%
                                                                                               temp_coord                        = zeros(length(cell_num_to_look_in_current_file),2); % set it to zero and leave it like that 
                                                                                                                                                                                      % if the file do not exist    
                                                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                       
                                                                                                                                                                                      
                                                                                                       Structnames      = dir(folder_add_file);
                                                                                                       N_to_test        = length(dir(folder_add_file));
                                                                                                       for uu = 1: N_to_test
                                                                                                           temp_name = Structnames(uu).name;
                                                                                                            if (length(temp_name) > 19)
                                                                                                               if strcmp(temp_name(end-17:end),'mesc - regions.mat')
                                                                                                                   name_to_retain = temp_name;                                                                                  
                                                                                                               end
                                                                                                            end  
                                                                                                        end   

                                                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                      
                                                                                                                                                                                      
                                                                                                 if exist([folder_add_file,slash,name_to_retain],'file') == 2
                                                                                                            load([folder_add_file,slash,name_to_retain]); 

                                                                                                            for ind_num_cell = 1: length(cell_num_to_look_in_current_file)
                                                                                                                        act_cell                    = cell_num_to_look_in_current_file(ind_num_cell);
                                                                                                                        [Coordx,Coordy]             = ind2sub([nx , ny],find(A(act_cell,:))); % dimensions of A : ncells* (nx*ny)
                                                                                                                         X_cord                     = round(mean(Coordx));
                                                                                                                         Y_cord                     = round(mean(Coordy));
                                                                                                                         temp_coord(ind_num_cell,1) = X_cord;
                                                                                                                         temp_coord(ind_num_cell,2) = Y_cord;
                                                                                                            end  
                                                                                                            
                                                                                                 else
                                                                                                                         temp_coord                 = zeros(length(cell_num_to_look_in_current_file),2);          
                                                                                                 end
                                                                                                                         Buff_temp_cord             = [Buff_temp_cord; temp_coord];
                                                                                     end 
                                                                                      
                                                                                     if length(find(Buff_temp_cord(:)))
                                                                                                                       All_data.data.Buffer_labels  =  [All_data.data.Buffer_labels,Buff_temp_cord];       
                                                                                     end
                                                                           end
                                                                    end
                                                                     
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                        
        end
        
 
        
 
        function Plot_Data(object_handle, event, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models)
        
         if Clu_count.data == 0
                if length(All_data.data)&&(length(All_info.data))
                    
                                Clu_count.data     = 1; % On initialise the compteur de clusters 
                                Resp               = All_data.data.Resp;
                                dt                 = All_data.data.dt;
                         
                                Resp_vect          = Resp(:);
                                numb_ele           = length(Resp_vect);                                
                                num_el             = ceil(numb_ele*.9);                                
                                Sorted_vect        = sort(Resp_vect);                               
                                Range_plots.data   = Sorted_vect(num_el);
                                
                                time               = ((1: size(Resp,2))-1)*dt;
                                Number_of_families = size(All_info.data,2);
                                Fus_Indexes        = [];

                                for u = 1 : Number_of_families
                                       Fus_Indexes = [Fus_Indexes; All_info.data(u).Fusi_Ind];
                                end   
                                 Num_plot          = Assign_plot_num(Fus_Indexes);          % Some stims ensambles are plotted together, so we give them a similar plot number
                                 Num_diff_plots    = max(Num_plot(:,2));
                                 Plots_index       = cell(1,Num_diff_plots); 
                                    for u = 1: Num_diff_plots
                                        Plots_index{1,u} = find(Num_plot(:,2) == u);
                                    end
                               if ~length(hand_plots.data)                                   % Create the figures  
                                   hand_plots.data.hand_figs  = cell(1,Num_diff_plots+2);
                                   hand_plots.data.hand_axes  = cell(1,Num_diff_plots+2);
                                  %hand_plots.data.hand_plots = cell(1,Num_diff_plots);
                                     for w = 1 : Num_diff_plots
                                                  ind_data    = Plots_index{1,w};
                                                   name       = All_info.data(ind_data(1)).Comm_nam; 
                                               if strcmp(name,'') 
                                                   name       = All_info.data(ind_data(1)).name;                                                   
                                               end    

                                               lines_pres                      = size(All_info.data(ind_data(1)).Index,1);
                                               cols_pres                       = size(All_info.data(ind_data(1)).Index,2);

                                               if .1*cols_pres > 1;   W = .8; else W = .1*cols_pres   ;end
                                               if .12*lines_pres*2 > 1; H = .9; else H =  .12*lines_pres*2*8/9;end 
                                               if  get( check_square,'Value'); W = .8; H = .9;end    
                                               
                                               if    get( check_square,'Value') 
                                                      hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'figure','ToolBar', 'auto');   
                                               else
                                                      hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'none','ToolBar', 'none');   
                                               end    
                                               hand_plots.data.hand_axes{1,w}  = cell(lines_pres,cols_pres);  
                                               %hand_plots.data.hand_plots{1,w} = cell(lines_pres,cols_pres);  
                                                     for i = 1:cols_pres
                                                       for j = 1: lines_pres
                                                            [ left0   bottom0  width0  height0]   = Dimensionate_frame(zeros(lines_pres,cols_pres),j,i);   
                                                             if w == 1
                                                                Width_cord  = width0; 
                                                                Height_cord = height0;
                                                             end
                                                             
                                                             if get(check_square,'Value')
                                                                hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) Width_cord*.8  Height_cord*.8],'units', 'normalized');   
                                                             else
                                                                hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) width0*.8  height0*.8],'units', 'normalized');   
                                                             end
                                                       end
                                                     end
                                     end
                                      %%%% Now the annotation plot
                                               hand_plots.data.hand_figs{1,Num_diff_plots+1}  = figure('Color','white','units', 'normalized'  ,'Position',[0 0.9 1 .05],'Name','Annotations','MenuBar', 'none','ToolBar', 'none');   
                                               hand_plots.data.hand_axes{1,Num_diff_plots+1}  = uicontrol('Style','text','units', 'normalized','Position',[0 0   1   1],'String','','backgroundcolor',[1 1 1]);
                                      %%%%
                            %  uicontrol('Style','text','Units','pixels','units', 'normalized','Position',[.01 (.7) width0*3/4 height0/3], 'String',name);
                               end 
                               for w = 1 : Num_diff_plots
                                     ind_data    = Plots_index{1,w};
                                    lines_pres   = size(All_info.data(ind_data(1)).Index,1);
                                    cols_pres    = size(All_info.data(ind_data(1)).Index,2);
 
                                    hand_plots.data.hand_figs{1,w}; 
                                         for i = 1:cols_pres
                                           for j = 1: lines_pres
                                                    indXX      = [];
                                                    t_stim     = All_info.data(Plots_index{1,w}(1)).t_bef_stim;
                                                    t_fin_stim = t_stim + All_info.data(Plots_index{w}(1)).Stim_len(j,i);
                                                    
                                                for zer  = 1:length(Plots_index{1,w})
                                                    indXX = [indXX;  All_info.data(Plots_index{1,w}(zer)).Index(j,i)];
                                                end
                                                if length(indXX)
                                                    
                                                    %%%%%%%%%  Modeling  details
                                                        [Bool_plot_mod,index_mod, index_stim] =  Boolean_plot_model_index_clu(indXX, Clu_count.data, All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)); 
                                                    %%%%%%%%%
                                                    
                                                     h_temp =   hand_plots.data.hand_axes{1,w}{j,i};    
                                                         if   indXX(1)
                                                             hold( h_temp, 'on')
                                                                plot(h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(1))),'Color',All_info.data(Plots_index{1,w}(1)).Color);  % if the index is not zero !!    
                                                                plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g');
                                                              if Bool_plot_mod
                                                                  Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
                                                                  plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(1))),'Color','k')      
                                                              end
                                                             hold( h_temp,'off') 
                                                        end
                                                          if length(indXX) >1
                                                                    hold( h_temp, 'on' )
                                                                       for uer = 2:length(indXX)
                                                                           if indXX(uer)
                                                                              plot( h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(uer))),'Color',All_info.data(Plots_index{1,w}(uer)).Color)
                                                                           end 
                                                                           
                                                                           if Bool_plot_mod
                                                                              Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
                                                                              plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(uer))),'Color','k')      
                                                                           end
                                                                         end  
                                                                              plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g');
                                                                    hold( h_temp, 'off' )
                                                          end 
                                                                    if prod((indXX  == 0))
                                                                        if i == 1
                                                                           set(h_temp,'xtick',[]);
                                                                           set(h_temp,'Xcolor', 'w')
                                                                        else    
                                                                          h_temp.Visible = 'off';
                                                                        end
                                                                    end   
                                                                    xlim(h_temp, [time(1) time(end)])
                                                                    ylim(h_temp, [-.45*Range_plots.data  Range_plots.data])
                                                end
                                                 if (i == 1)
                                                    h_temp.YLabel.String  =  All_info.data(ind_data(1)).ylabs{j};
                                                 end    
                                                 if j < lines_pres
                                                    set(h_temp, 'XTickLabel', []) 
                                                 end
                                                 if i > 1
                                                    set(h_temp, 'YTickLabel', []) 
                                                 end
                                                 if j == lines_pres
                                                     h_temp.XLabel.String =  All_info.data(ind_data(1)).xlabs{i};
                                                 end  
                                          end        
                                         end          
                               end    
                     %%%% Update the annotations of the first cluster 
                             hand_plots.data.hand_figs{1,Num_diff_plots+1};         
                             h_temp =  hand_plots.data.hand_axes{1,Num_diff_plots+1};  
                             STR = '';
                             
                             if length(All_data.data.Annotations{Clu_count.data,1})
                                      for uu= 1:size(All_data.data.Annotations{Clu_count.data,1},1)
                                              str_class   =  All_data.data.Annotations{Clu_count.data,1}{uu,1};
                                              str_Sclass  =  All_data.data.Annotations{Clu_count.data,1}{uu,2};
                                              STR         = [STR, str_class, '/',str_Sclass, '      '];
                                      end    
                             end
                                              set(h_temp,'String',STR); 
                      %%%%
                     txt_count_clu.String = num2str(Clu_count.data);
                     txt_min_clu.String   = '1';
                     txt_max_clu.String   = num2str(size(All_data.data.Resp,1));
                     if length(All_data.data.Liste_cells_cluster)
                         set(txt_act_numC,'String', num2str(length(All_data.data.Liste_cells_cluster{Clu_count.data}))); 
                     end  
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Cells  spatial position %%%%%%%%%%%%%%%%%
                         
                          if size(All_data.data.Buffer_labels,2) == 6   %%%%% This means that the spatial info of the cells was collected
                           
                                 Temp_list_clust                 = All_data.data.Liste_cells_cluster; 
                                 Temp_list_to_highlight          = Temp_list_clust{Clu_count.data};
                                 Temp_list_clust(Clu_count.data) = [];
                                 List_other_cells                = cell2mat(Temp_list_clust);

                                 Spatial_info_other_cells        = All_data.data.Buffer_labels(List_other_cells,[3,5,6]);
                                 Spatial_info_cells              = All_data.data.Buffer_labels(Temp_list_to_highlight,[3,5,6]);
  
                                 %%%% (Do not ?) plot the cells that do not
                                 %%%% have full spatial information 
                                 
                                 indxdx                           = find(prod(Spatial_info_other_cells,2));
                                 Spatial_info_other_cells         = Spatial_info_other_cells(indxdx,:); 
                                 
                                 indxdx                           = find(prod(Spatial_info_cells,2));
                                 Spatial_info_cells               = Spatial_info_cells(indxdx,:); 
                                 
                                 hand_plots.data.hand_figs{1,Num_diff_plots+2} =   figure('Color','white','units', 'normalized'  ,'Position',[0.6 0.5 .4 .5],'Name','Spatial information');  
                                 hand_plots.data.hand_axes{1,Num_diff_plots+2} =   axes('Position',[.12 .1 .8 .8]);
                                 h_temp                                        =   hand_plots.data.hand_axes{1,Num_diff_plots+2};
                                 view(h_temp,[-62, 29.2]);
                                              plot3(h_temp,Spatial_info_other_cells(:,2),Spatial_info_other_cells(:,3),Spatial_info_other_cells(:,1) ,'.','Color',[.65 .65 .65])
                                         hold(h_temp,'on')
                                              plot3(h_temp,Spatial_info_cells(:,2),Spatial_info_cells(:,3),Spatial_info_cells(:,1),'.r','MarkerSize',10)
                                         hold(h_temp,'off')
                                              set(h_temp, 'ZDir', 'reverse'); 
                                              zlabel(h_temp,'Depth (µm)')
                           end
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                end
         end
        end
        
        
%          function Plot_Data2(All_data, All_info, hand_plots, Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models)    % Is the same as plot, exept that handles and events are not arguments
%              if Clu_count.data
%                 if length(All_data.data)&&(length(All_info.data))
%                                  Resp               = All_data.data.Resp;
%                                  dt                 = All_data.data.dt;
% %                          
% %                                 Resp_vect          = Resp(:);
% %                                 numb_ele           = length(Resp_vect);                                
% %                                 num_el             = ceil(numb_ele*.9);                                
% %                                 Sorted_vect        = sort(Resp_vect);                               
% %                                 Range_plots.data   = Sorted_vect(num_el);
% %                                 
%                                 time               = ((1: size(Resp,2))-1)*dt;
%                                 Number_of_families = size(All_info.data,2);
%                                 Fus_Indexes        = [];
%                                 for u = 1 : Number_of_families
%                                        Fus_Indexes = [Fus_Indexes; All_info.data(u).Fusi_Ind];
%                                 end    
%                                        Num_plot    = Assign_plot_num(Fus_Indexes);          % Some stims ensambles are plotted together, so we give them a similar plot number
%                                   Num_diff_plots   = max(Num_plot(:,2));
%                                  Plots_index       =  cell(1,Num_diff_plots); 
%                                     for u = 1: Num_diff_plots
%                                         Plots_index{1,u} = find(Num_plot(:,2) == u);
%                                     end
%                                  
%                                if ~length(hand_plots.data)                                   % Create the figures  
%                                    hand_plots.data.hand_figs  = cell(1,Num_diff_plots+2);
%                                    hand_plots.data.hand_axes  = cell(1,Num_diff_plots+2);
%                                    %hand_plots.data.hand_plots = cell(1,Num_diff_plots);
% 
%                                      for w = 1 : Num_diff_plots
%                                                   ind_data    = Plots_index{1,w};
%                                                    name       = All_info.data(ind_data(1)).Comm_nam; 
%                                                if strcmp(name,'') 
%                                                    name       = All_info.data(ind_data(1)).name;                                                   
%                                                end    
%                                            lines_pres                      = size(All_info.data(ind_data(1)).Index,1);
%                                            cols_pres                       = size(All_info.data(ind_data(1)).Index,2);
%                                                if .1*cols_pres > 1;   W = .8; else W = .1*cols_pres   ;end
%                                                if .12*lines_pres*2 > 1; H = .9; else H =  .12*lines_pres*2*8/9;end 
%                                                if  get( check_square,'Value'); W = .8; H = .9;end    
%                                                
%                                                if    get( check_square,'Value') 
%                                                       hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'figure','ToolBar', 'auto');   
%                                                else
%                                                       hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'none','ToolBar', 'none');   
%                                                end  
%                                                hand_plots.data.hand_axes{1,w}  = cell(lines_pres,cols_pres);  
%                                                %hand_plots.data.hand_plots{1,w} = cell(lines_pres,cols_pres);  
%                                                      for i = 1:cols_pres
%                                                        for j = 1: lines_pres
%                                                             [ left0   bottom0  width0  height0]   = Dimensionate_frame(zeros(lines_pres,cols_pres),j,i);   
%                                                              if w == 1
%                                                                 Width_cord  = width0; 
%                                                                 Height_cord = height0;
%                                                              end
%                                                              if get(check_square,'Value')
%                                                                 hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) Width_cord*.8  Height_cord*.8],'units', 'normalized');   
%                                                              else
%                                                                 hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) width0*.8  height0*.8],'units', 'normalized');   
%                                                              end
%                                                        end
%                                                      end
%                                      end
%                             %  uicontrol('Style','text','Units','pixels','units', 'normalized','Position',[.01 (.7) width0*3/4 height0/3], 'String',name);
%                                end 
%                                for w = 1 : Num_diff_plots
%                                     ind_data     = Plots_index{1,w};
%                                     lines_pres   = size(All_info.data(ind_data(1)).Index,1);
%                                     cols_pres    = size(All_info.data(ind_data(1)).Index,2);
%  
%                                     hand_plots.data.hand_figs{1,w}; 
%  
%                                          for i = 1:cols_pres
%                                            for j = 1: lines_pres
%                                                     indXX  = [];
%                                                 t_stim     = All_info.data(Plots_index{1,w}(1)).t_bef_stim;
%                                                 t_fin_stim = t_stim + All_info.data(Plots_index{w}(1)).Stim_len(j,i);
%                                                     
%                                                 for zer  = 1:length(Plots_index{1,w})
%                                                     indXX = [indXX;  All_info.data(Plots_index{1,w}(zer)).Index(j,i)];
%                                                 end
%                                                 if length(indXX)
%                                                      %%%%%%%%%  Modeling  details
%                                                         [Bool_plot_mod,index_mod, index_stim] =  Boolean_plot_model_index_clu(indXX, Clu_count.data, All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)); 
%                                                     %%%%%%%%%
%                                                     
%                                                      h_temp =   hand_plots.data.hand_axes{1,w}{j,i};    
%                                                      cla(h_temp);
%                                                          if   indXX(1)
%                                                              hold(h_temp,'on') 
%                                                                 plot(h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(1))),'Color',All_info.data(Plots_index{1,w}(1)).Color);  % if the index is not zero !!     
%                                                                 plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g') 
%                                                               if Bool_plot_mod
%                                                                 Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
%                                                                 plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(1))),'Color','k')      
%                                                               end
%                                                              hold(h_temp,'off') 
%                                                          end
%                                                           if length(indXX) >1
%                                                                     hold( h_temp, 'on' )
%                                                                        for uer = 2:length(indXX)
%                                                                            if indXX(uer)
%                                                                               plot( h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(uer))),'Color',All_info.data(Plots_index{1,w}(uer)).Color)
%                                                                               if Bool_plot_mod
%                                                                                 Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
%                                                                                 plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(uer))),'Color','k')      
%                                                                               end
%                                                                            end 
%                                                                        end  
%                                                                               plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g') 
%                                                                     hold( h_temp, 'off' )
%                                                           end 
%                                                                      if prod((indXX  == 0))
%                                                                         if i == 1
%                                                                            set(h_temp,'xtick',[]);
%                                                                            set(h_temp,'Xcolor', 'w')
%                                                                         else    
%                                                                           h_temp.Visible = 'off';
%                                                                         end
%                                                                      end  
%                                                                     xlim(h_temp, [time(1) time(end)])
%                                                                     ylim(h_temp, [-.45*Range_plots.data  Range_plots.data])
%                                                 end
%                                                  if (i == 1)
%                                                     h_temp.YLabel.String  =  All_info.data(ind_data(1)).ylabs{j};
%                                                  end    
%                                                  if j < lines_pres
%                                                     set(h_temp, 'XTickLabel', []) 
%                                                  end
%                                                  if i > 1
%                                                     set(h_temp, 'YTickLabel', []) 
%                                                  end
%                                                  if j == lines_pres
%                                                      h_temp.XLabel.String =  All_info.data(ind_data(1)).xlabs{i};
%                                                  end  
%                                            end        
%                                          end          
%                                end    
%                      %%%% Update the annotations of the first cluster 
%                              hand_plots.data.hand_figs{1,Num_diff_plots+1};         
%                              h_temp =  hand_plots.data.hand_axes{1,Num_diff_plots+1};         
%                              STR    = '';
% 
%                               if length(All_data.data.Annotations{Clu_count.data,1})
%                                       for uu= 1:size(All_data.data.Annotations{Clu_count.data,1},1)
%                                              % n_class = All_data.data.Annotations{Clu_count.data,1}(uu,1);
%                                              % n_sub_c = All_data.data.Annotations{Clu_count.data,1}(uu,2);
%                                              % tmpx    = All_data.data.SubCats_Annotation{n_class,1};
%                                               str_class   =  All_data.data.Annotations{Clu_count.data,1}{uu,1};
%                                               str_Sclass  =  All_data.data.Annotations{Clu_count.data,1}{uu,2};
%                                               STR         = [STR, str_class, '/',str_Sclass, '      '];
%                                       end    
%                               end
%                                                set(h_temp,'String',STR);   
%                       %%%%         
%                      txt_count_clu.String = num2str(Clu_count.data);
%                      txt_min_clu.String   = '1';
%                      txt_max_clu.String   = num2str(size(All_data.data.Resp,1));
%                      if length(All_data.data.Liste_cells_cluster)
%                          set(txt_act_numC,'String', num2str(length(All_data.data.Liste_cells_cluster{Clu_count.data}))); 
%                      end  
%                      
%                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Cells  spatial position %%%%%%%%%%%%%%%%%
%                        if size(All_data.data.Buffer_labels,2) == 6   %%%%% This means that the spatial info of the cells was collected
%                            
%                                  Temp_list_clust                 = All_data.data.Liste_cells_cluster; 
%                                  Temp_list_to_highlight          = Temp_list_clust{Clu_count.data};
%                                  Temp_list_clust(Clu_count.data) = [];
%                                  List_other_cells                = cell2mat(Temp_list_clust);
% 
%                                  Spatial_info_other_cells        = All_data.data.Buffer_labels(List_other_cells,[3,5,6]);
%                                  Spatial_info_cells              = All_data.data.Buffer_labels(Temp_list_to_highlight,[3,5,6]);
%   
%                                  %%%% (Do not ?) plot the cells that do not
%                                  %%%% have full spatial information 
%                                  
%                                  indxdx                           = find(prod(Spatial_info_other_cells,2));
%                                  Spatial_info_other_cells         = Spatial_info_other_cells(indxdx,:); 
%                                  
%                                  indxdx                           = find(prod(Spatial_info_cells,2));
%                                  Spatial_info_cells               = Spatial_info_cells(indxdx,:); 
%                                  
%                                  hand_plots.data.hand_figs{1,Num_diff_plots+2};     
%                                  h_temp                          = hand_plots.data.hand_axes{1,Num_diff_plots+2};
%                                  [az,el]                         = view(h_temp);
%                                  cla(h_temp)
%                                               plot3(h_temp,Spatial_info_other_cells(:,2),Spatial_info_other_cells(:,3),Spatial_info_other_cells(:,1) ,'.','Color',[.65 .65 .65])
%                                          hold(h_temp,'on')
%                                               plot3(h_temp,Spatial_info_cells(:,2),Spatial_info_cells(:,3),Spatial_info_cells(:,1),'.r','MarkerSize',10)
%                                          hold(h_temp,'off')
%                                               set(h_temp, 'ZDir', 'reverse'); 
%                                               zlabel(h_temp,'Depth (µm)')
%                                               view(h_temp,az,el);
%                        end
%                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                 end
%              end
%          end
          
         function Print(object_handle, event,All_info, hand_plots, Clu_count)
              if isunix || ismac
                slash = '/';
              elseif ispc
                slash = '\';
              end    
              if length(hand_plots.data)
                       ok     = 0;
                       choice = questdlg('Save all the figures', '', 'Create directory and save all the figures there','Put all figs in an existing file','Cancel','Put all figs in an existing file');
                                                    switch choice
                                                        case 'Create directory and save all the figures there'
                                                            
                                                                     prompt   = {''};
                                                                     title    = 'Folder name';
                                                                     dims     = [1 35];
                                                                     definput = {['Cluster_',num2str(Clu_count.data)]};
                                                                     answer   = inputdlg(prompt,title,dims,definput);
                                                                     if length(answer)
                                                                                folder_name = uigetdir(['.',slash],'Choose pathway in which to save the folder');
                                                                                if ischar(folder_name)
                                                                                      mkdir([folder_name,slash,answer{1,1}])
                                                                                      folder_name = [folder_name,slash,answer{1,1}];
                                                                                      ok          = 1;
                                                                                end
                                                                     end    
                                                            case 'Put all figs in an existing file'
                                                              folder_name = uigetdir;
                                                              if ischar(folder_name)
                                                                  ok = 1;
                                                              end                                                              
                                                        case  'Cancel'
                                                                  ok = 0;
                                                    end
                    if ok     % Choose the file format : eps, png, fig
                             ok2    = 0;
                             while ok2 == 0
                              choice = questdlg('File format', '', 'eps','png','fig','png');
                               if length(choice)    
                                  format = choice;
                                  ok2    = 1;
                               end         
                             end  
                    end    
                    if ok && ok2
                            for u = 1:size(hand_plots.data.hand_figs,2)
                                     h    =  hand_plots.data.hand_figs{1,u};
                                     name =  hand_plots.data.hand_figs{1,u}.Name; 
                                     saveas(h,[folder_name,slash,name,'_cluster_',num2str(Clu_count.data),'.',format])
                            end
                    end
            else  msgbox('Load first the data and plot the figures !')
            end
         end
        
        function Prev(object_handle, event,All_data, All_info, hand_plots,Clu_count, txt_count_clu,txt_min_clu,txt_max_clu, Range_plots, check_square,list_Annots,txt_act_numC,list_mod,All_models)
        
           val      = get(list_Annots,'Value');
           act_val  = get(list_Annots,'String');
            if Clu_count.data        % a non zero cluster count states that the plots are already done
                     if   strcmp('default', act_val{val}) 
                        act = Clu_count.data;
                        if (act-1 ~= 0)
                            Clu_count.data        = Clu_count.data - 1;
                            txt_count_clu.String  = num2str(Clu_count.data);
                            Plot_Data2(All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod,All_models) ;
                           end
                     else   
                            liste_act             = All_data.data.Lists{val,2};
                            n_act_in_list         = find(Clu_count.data ==liste_act);
                            if ~length(n_act_in_list)
                                 Clu_count.data   = liste_act(1);
                                 txt_count_clu.String  = num2str(Clu_count.data);
                                 Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod,All_models) ;
                            else
                                  if  (Clu_count.data  > liste_act(1))&&( Clu_count.data <= liste_act(end) )
                                        Clu_count.data        = liste_act(n_act_in_list-1);
                                        txt_count_clu.String  = num2str(Clu_count.data);
                                        Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod,All_models) ;
                                  elseif (Clu_count.data  == liste_act(1))
                                        txt_count_clu.String  = num2str(Clu_count.data);
                                        Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod,All_models) ;
                                  end   
                            end
                     end
            end
          end
        
         function Next(object_handle, event,All_data, All_info, hand_plots,Clu_count, txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models)
           val      = get(list_Annots,'Value');
           act_val  = get(list_Annots,'String');
          if Clu_count.data
                if   strcmp('default', act_val{val}) 
                        act = Clu_count.data;
                        if length(All_data.data)
                            Num_max_clu = size(All_data.data.Resp,1);
                              if (act+1 <= Num_max_clu)
                                  Clu_count.data        = Clu_count.data + 1;
                                  txt_count_clu.String  = num2str(Clu_count.data);
                                  Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models) ;
                             end 
                        end
                else        
                            liste_act             = All_data.data.Lists{val,2};
                            n_act_in_list         = (find(Clu_count.data == liste_act));
                            if ~length(n_act_in_list)
                                 Clu_count.data   = liste_act(1);
                                 txt_count_clu.String  = num2str(Clu_count.data);
                                 Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models) ;
                            else
                                  if  (Clu_count.data  >= liste_act(1))&&( Clu_count.data < liste_act(end))
                                        Clu_count.data        = liste_act(n_act_in_list+1);
                                        txt_count_clu.String  = num2str(Clu_count.data);
                                        Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models) ;
                                  end  
                            end
                end
          end
         end
        
        
        function Set_cluster_num(object_handle, event, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu,txt_max_clu,Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models)
               if length(All_data.data)&&(Clu_count.data)
                              val      = get(list_Annots,'Value');
                              act_val  = get(list_Annots,'String');
                              a        = str2num(get(object_handle,'String'));
                                  if   strcmp('default', act_val{val})
                                                   if (~strcmp(txt_min_clu.String,''))&&(~strcmp(txt_max_clu.String,''))
                                                       if (a >= str2num(txt_min_clu.String))&&(a <= str2num(txt_max_clu.String))
                                                              Clu_count.data        = a; 
                                                              txt_count_clu.String  = num2str(a);
                                                              Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models) ;
                                                              object_handle.String  = '';
                                                       else
                                                              msgbox('Please enter a valid cluster number !')    
                                                       end
                                                   end
                                  else  
                                                liste_act             = All_data.data.Lists{val,2};
                                                n_act_in_list         = (find(a == liste_act));
                                                if ~length(n_act_in_list)
                                                     msgbox(['This cluster is not in the list ',All_data.data.Lists{val,1}])
                                                     object_handle.String  = '';
                                                else
                                                     Clu_count.data        = a;
                                                     txt_count_clu.String  = num2str(a);

                                                     Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models) ;
                                                     object_handle.String  = '';
                                                     if length(All_data.data.Liste_cells_cluster)
                                                                  set(txt_act_numC,'String', num2str(length(All_data.data.Liste_cells_cluster{Clu_count.data}))); 
                                                     end
                                                 end   
                                  end
               else      
                    msgbox('first load the data and plot it')              
               end
        end
         
        function Plus_range(object_handle, event,All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots)  % increases the range of visualisation
                Range_plots.data = Range_plots.data*.8;
             %    Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots) 
        end
        
        function Minus_range(object_handle, event,All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots)  % decreases the range of visualisation
                Range_plots.data = Range_plots.data*1.2;
              %   Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots) 
        end
        
        function Annotate(object_handle, event,All_data,Clu_count,hand_plots,All_info)
                  Annotate_clu 
        end
         
        function Save_Annot(object_handle, event, All_data)
           [filename, pathname] = uiputfile({'*.mat'});
           if isstr(filename)
                  Responses          = struct;
                  Responses.TracesDg = All_data.data.Resp;
                  Responses.dt       = All_data.data.dt;
                  Cats_Annotation    = All_data.data.Cats_Annotation;
                  SubCats_Annotation = All_data.data.SubCats_Annotation;
                  Annotations        = All_data.data.Annotations;
                  Lists              = All_data.data.Lists;
                  List_Raw_files     = All_data.data.List_Raw_files;
                  Liste_cells_cluster= All_data.data.Liste_cells_cluster;
                  Buffer_labels      = All_data.data.Buffer_labels;        % Buffer labels : 4 cols :     # of mice | index file in list of files |  Depth (µm)  |  cell # in recording  
                  Stims              = All_data.data.Stims;
                  
                  save([pathname,filename],'Responses', 'Cats_Annotation','SubCats_Annotation','Annotations','Lists','List_Raw_files','Liste_cells_cluster','Buffer_labels','Stims');        
             end    
        end
         
        
        function Close_Plots(object_handle, event, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu)
        
            if length(hand_plots.data)
               for w = 1 : length(hand_plots.data.hand_figs)
                     htemp = hand_plots.data.hand_figs{1,w};
                      %if ~isdouble(htemp)
                      %   if isvalid(htemp)
                          close(htemp)
                      %   end  
                      %end
               end
            end
             Clu_count.data       =  0;
             txt_count_clu.String = '';
             txt_min_clu          = '';
             txt_max_clu          = '';  
             hand_plots.data      = []; % Tue les pointeurs, il faut replotter les figures... 
        end
        
        
        function Visu_List(object_handle, event, All_data,list_Annots) 
            Annots = ~cellfun(@isempty,All_data.data.Annotations);
            if sum(Annots) % s'il y a des annotations ! 
                List_create
             else    
                msgbox('You must first annotate the signals !')
            end 
        end
        
        function Erase_List(object_handle, event, All_data,list_Annots)
           val      = get(list_Annots,'Value');
           act_val  = get(list_Annots,'String');
           if val == 1
               msgbox('You can not erase the default list ! ')
           else
                                               choice = questdlg(['Delete list  ',act_val{val}, ' ?'] , 'Confirmation ','Yes','No','Yes');
                                                % Handle response
                                                switch choice
                                                    case 'Yes'
                                                          All_data.data.Lists(val,:) = [];
                                                          
                                                          temp     = (All_data.data.Lists(1:end,1))';
                                                          set(list_Annots,'String',temp);
                                                          set(list_Annots,'Value',1);
                                                 end
          end
        end
        
        
        function  Model_create(object_handle, event, All_data, All_info, list_mod,All_models)
                  Model_creator
        end
        
         
%         function Refit(object_handle, event, All_data, All_info, list_mod, All_models)
%                  Model_refit
%         end
        
        
        
        function Load_Models(object_handle, event,txt_models_Add,All_models,list_mod)
        
                   [filename, pathname]                          = uigetfile({'*.mat'});
                   if isstr(filename)   
                               
                            load([pathname,filename]);
                              if exist('Mods')    
                                        num_mod         = size(Mods,1);
                                        All_models.data = [];
                                        Str             = cell(1,num_mod);
                                              for n = 1:num_mod
                                                        temp_struc                         = struct;
                                                        temp_struc.name                    = Mods(n).name; 
                                                        temp_struc.Parameters              = Mods(n).Parameters;
                                                        temp_struc.Name_model              = Mods(n).Name_model;
                                                        temp_struc.Ind_stims               = Mods(n).Ind_stims;
                                                        temp_struc.Liste_clusters          = Mods(n).Liste_clusters;
                                                        temp_struc.Data_fit                = Mods(n).Data_fit;

                                                        All_models.data                    = [All_models.data;temp_struc];
                                                        Str{1,n}                           = Mods(n).name;
                                              end
                                                        set(list_mod,'String',Str);
                                                        set(list_mod,'Value', 1);
                                                        set(txt_models_Add,'String',filename);
                              else                
                                           msgbox('The file didn''t contained a model in the right format')            
                              end
                   else               
                                           msgbox('There was no model ')            
                   end
        end
        
        
        function Model_save(object_handle, event, All_data, All_models)
                
           [filename, pathname] = uiputfile({'*.mat'});
           if isstr(filename)
                 % Responses          = struct;
                 % Responses.TracesDg = All_data.data.Resp;
                 % Responses.dt       = All_data.data.dt;
                  
                n_struct  = size(All_models.data,1);
                 
                if n_struct >1
                     Mods = [];                    
                     for uu = 1: n_struct 
                          temp_struc                  = struct;
                          temp_struc.name             = All_models.data(uu).name; 
                          temp_struc.Parameters       = All_models.data(uu).Parameters;
                          temp_struc.Name_model       = All_models.data(uu).Name_model;
                          temp_struc.Ind_stims        = All_models.data(uu).Ind_stims;
                          temp_struc.Liste_clusters   = All_models.data(uu).Liste_clusters;
                          temp_struc.Data_fit         = All_models.data(uu).Data_fit;
                          Mods                        = [Mods;temp_struc];
                     end
                          save([pathname,filename],'Mods');%%%%%%'Responses', 'Cats_Annotation','SubCats_Annotation','Annotations','Lists','List_Raw_files','Liste_cells_cluster','Buffer_labels','Stims');        
                else
                          msgbox('There are no saved models !')
                end 
             end 
        end
        
        function   Eval_mod(object_handle, event,All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models) 
                   Eval_model;
        end              
        
        
        