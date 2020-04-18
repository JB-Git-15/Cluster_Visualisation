%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualize single cells and clusters%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % out of date version ?      

        dimS      = get(0,'ScreenSize');  
        hC        = figure('Color','white','units', 'normalized','Position',[.1 0 .2 1],'Name','Visualisation','MenuBar', 'none','ToolBar', 'none');   
     
                    ws               = evalin('base','whos');
                    ALL_info_present = length(find( strcmp({ws.name}, 'All_info')));
                    
                    
                if ALL_info_present
                    Strng = 'Visu parameters loaded !';
                else
                    Strng = '';
                    All_info  = Passage_par_ref([]);  % This applies to the case in which we initialise directly thee script "Visu_cells_and_clusters", withouth passing 
                                                      % by the precedent steps 
                end
                    
                
        edit_pars         = uicontrol('Style','text','units', 'normalized','position', [0.1 0.85 0.8 0.04],'String',Strng);
   
        
       %%%%%%%%%%%%   First be sure of having the visualisation parameters
       %%%%%%%%%%%%   before everithing.... 
        
        butt_Load_pars    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.9 0.8 0.04],'String','Load visualisation parameters ','callback',{@Load_Pars, All_info, edit_pars});  
        All_data          = Passage_par_ref([]);        
        
        
        %%%%%%%%%%%%%   Load raw data/ Load already clustered data
        
        
       dir_rawdat   = uicontrol('Style','text','units', 'normalized','position', [0.1 0.7 0.8 0.04],'String','');
       butt_rawdat  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.75 0.8 0.04],'String','Load data','callback',{@Load_Data,All_data,dir_rawdat});
  
        
       
       %%%%%%%%%%%%%% Plot all the data... 
       %%%%%%%%%%%%% Cluster counter and 
       Clu_count    = Passage_par_ref(1);
       Range_plots  = Passage_par_ref(0);
       
       hand_plots   = Passage_par_ref([]);
        
       
       txt_count_clu= uicontrol('Style','text','units', 'normalized','position', [0.6 0.45 0.2 0.04],'String','');
       txt_min_clu  = uicontrol('Style','text','units', 'normalized','position', [0.44  0.5 0.05 0.04],'String','');
       txt_max_clu  = uicontrol('Style','text','units', 'normalized','position', [0.72  0.5 0.15 0.04],'String','');

       butt_plot    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.6 0.8 0.04],'String','Plot data','callback',{@Plot_Data, All_data, All_info, hand_plots, Clu_count, txt_count_clu,txt_min_clu,txt_max_clu, Range_plots});
 
       butt_left    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.5  0.5 0.1 0.04],'String','<-','callback',{@Prev, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots});
       butt_right   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.61 0.5 0.1 0.04],'String','->','callback',{@Next, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots});
                                                                                                                                          
       btt_clos_plt = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1 0.15 0.8 0.04],'String','Close Plots','callback',{@Close_Plots, hand_plots, Clu_count, txt_count_clu});
       
       txt_zoom     = uicontrol('Style','text','units', 'normalized','position', [0.1  0.35 0.3 0.04],'String','Zoom y');
       btt_plus_rg  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.41 0.37 0.1 0.04],'String','+','callback',{@Plus_range,  All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});       
       btt_min_rg   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.41 0.32 0.1 0.04],'String','-','callback',{@Minus_range, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});
       ed_set_clu_n = uicontrol('Style','edit','units','normalized','position',[0.44  0.45 0.1 0.04],'String','','callback',{@Set_cluster_num, All_data, All_info, hand_plots, Clu_count, txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});
   
       
       
       
       
        function Load_Pars(object_handle, event, All_info, edit_pars)
        
            filename = 0;
              while (filename == 0)
                       [filename,path] = uigetfile;   

                   if  filename  == 0
                        msgbox('please enter a valid path')
                   else    
                       load([path,filename]);
                        All_info.data = Struc.data;
                        set(edit_pars,'String',[filename]); 
                   end 
                
              end 
        end
        
        function Load_Data(object_handle, event,All_data,dir_rawdat)
        
        
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
                                                           index       = find(folder_name == '/');
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
                                                             if exist([folder_name,'/','Data.mat'])
                                                                    load([folder_name,'/','Data.mat'])
                                                                   %   listOfVariables = who('-file',[folder_name,'/','Data.mat']);
                                                                   %   Is =  ismember('profondeur', listOfVariables); % returns true
                                                                 % if ~Is
                                                                   %   answer = inputdlg(['Enter depth (µm) ', folder_name], 'Sample', [1 50]);
                                                                    %  if length(answer{1})
                                                                     %        profondeur = str2double(answer);
                                                                    % %%        save([folder_name,'/','Data.mat'], 'profondeur', '-append')
                                                                     %        Depths(uu) = profondeur;
                                                                     % else
                                                                      %       Depths(uu) = 0;
                                                                     % end    
                                                                %  else
                                                                    %         Depths(uu) = profondeur;
                                                                  %end  
                                                             else
                                                                     Responses                =  Data2Stim(folder_name, folder_name);
                                                             end
                                                                     Resp                     =  cat(1,Resp,Responses.TracesDg);   
                                                                     %Resp_chosen              =   Resp; 
                                                                     %[n_cells,n_time,n_stim]  =   size(Resp);
                                                                     %Resp_resh                =   reshape(Resp,[n_cells, n_time*n_stim]);
                                                                     %Buffer                   =   [Buffer; Resp_chosen_resh];     
                                                
                                                  end
                                                                     All_data.data      = struct;
                                                                     All_data.data.Resp = Resp;    % Assign all the data to the     
                                                                     All_data.data.dt   = Responses.dt;
                                                                     
                                                                     set(dir_rawdat,'String','Data loaded ! ')
        end
        
        
        
        function  Num_struct_num_plot    = Assign_plot_num(Fus_Indexes)
        
            n_tot           = length(Fus_Indexes);
 
            n_max_Fus_index = max(Fus_Indexes); 
            indn_plts_alone = find(Fus_Indexes ==0);
            
            if length(indn_plts_alone)
                Num_plot =  Fus_Indexes; 
                compt    =  n_max_Fus_index +1; 
                
                for zz = 1 : length(indn_plts_alone)
                    Num_plot(indn_plts_alone(zz)) = compt;
                    compt                         = compt +1;
                end    
            else
                Num_plot =  Fus_Indexes;               
            end 
                Num_struct_num_plot = [[1:length(Num_plot)]',Num_plot];
          end
        
        
 
        function Plot_Data(object_handle, event, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots)
        
        
                if length(All_data.data)&&(length(All_info.data))
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
                                       Num_plot    = Assign_plot_num(Fus_Indexes);          % Some stims ensambles are plotted together, so we give them a similar plot number
                                  Num_diff_plots   = max(Num_plot(:,2));
                                 Plots_index       =  cell(1,Num_diff_plots); 
                                 
                                    for u = 1: Num_diff_plots
                                        Plots_index{1,u} = find(Num_plot(:,2) == u);
                                    end
                                 
                               if ~length(hand_plots.data)                                   % Create the figures  
                                  
                                   hand_plots.data.hand_figs  = cell(1,Num_diff_plots);
                                   hand_plots.data.hand_axes  = cell(1,Num_diff_plots);
                                   hand_plots.data.hand_plots = cell(1,Num_diff_plots);

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
                                               %   W = .8;
                                               %   H = .9;
                                                
                                               
                                               hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'none','ToolBar', 'none');   
                                               hand_plots.data.hand_axes{1,w}  = cell(lines_pres,cols_pres);  
                                               hand_plots.data.hand_plots{1,w} = cell(lines_pres,cols_pres);  

                                              
                                               
                                                     for i = 1:cols_pres
                                                       for j = 1: lines_pres
                                                            [ left0   bottom0  width0  height0]   = Dimensionate_frame(zeros(lines_pres,cols_pres),j,i);   
                                                             hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) width0*.8  height0*.8],'units', 'normalized');   
                                                       end
                                                     end
                                     end
                            %  uicontrol('Style','text','Units','pixels','units', 'normalized','Position',[.01 (.7) width0*3/4 height0/3], 'String',name);
                               end 
                                
  
                               for w = 1 : Num_diff_plots

                                     ind_data    =  Plots_index{1,w};
                                    lines_pres   = size(All_info.data(ind_data(1)).Index,1);
                                    cols_pres    = size(All_info.data(ind_data(1)).Index,2);
 
                                    hand_plots.data.hand_figs{1,w}; 
 
                                         for i = 1:cols_pres
                                           for j = 1: lines_pres
                                                    indXX = [];
                                                 for zer  = 1:length(Plots_index{1,w})
                                                    indXX = [indXX;  All_info.data(Plots_index{1,w}(zer)).Index(j,i)];
                                                 end
                                                 
                                                if length(indXX)
                                                     h_temp =   hand_plots.data.hand_axes{1,w}{j,i};    
                                                         if   indXX(1)
                                                              plot(h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(1))),'Color',All_info.data(Plots_index{1,w}(1)).Color);  % if the index is not zero !!     
                                                         end
                                                          if length(indXX) >1
                                                                    hold( h_temp, 'on' )
                                                                       for uer = 2:length(indXX)
                                                                           if indXX(uer)
                                                                              plot( h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(uer))),'Color',All_info.data(Plots_index{1,w}(uer)).Color)
                                                                           end 
                                                                       end  
                                                                    hold( h_temp, 'off' )
                                                          end 
                                                                    if prod((indXX  == 0))
                                                                        h_temp.Visible = 'off';
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
  
                     txt_count_clu.String = num2str(Clu_count.data);
                     txt_min_clu.String   = '1';
                     txt_max_clu.String   = num2str(size(All_data.data.Resp,1));
                end
        end
        
        
        
         function Plot_Data2(All_data, All_info, hand_plots, Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots)    % Is the same as plot, exept that handles and events are not arguments

             
                if length(All_data.data)&&(length(All_info.data))
                                 Resp               = All_data.data.Resp;
                                 dt                 = All_data.data.dt;
%                          
%                                 Resp_vect          = Resp(:);
%                                 numb_ele           = length(Resp_vect);                                
%                                 num_el             = ceil(numb_ele*.9);                                
%                                 Sorted_vect        = sort(Resp_vect);                               
%                                 Range_plots.data   = Sorted_vect(num_el);
%                                 
                                time               = ((1: size(Resp,2))-1)*dt;
                                Number_of_families = size(All_info.data,2);
                                Fus_Indexes        = [];

                                for u = 1 : Number_of_families
                                       Fus_Indexes = [Fus_Indexes; All_info.data(u).Fusi_Ind];
                                end    
                                       Num_plot    = Assign_plot_num(Fus_Indexes);          % Some stims ensambles are plotted together, so we give them a similar plot number
                                  Num_diff_plots   = max(Num_plot(:,2));
                                 Plots_index       =  cell(1,Num_diff_plots); 
                                 
                                    for u = 1: Num_diff_plots
                                        Plots_index{1,u} = find(Num_plot(:,2) == u);
                                    end
                                 
                               if ~length(hand_plots.data)                                   % Create the figures  
                                  
                                   hand_plots.data.hand_figs  = cell(1,Num_diff_plots);
                                   hand_plots.data.hand_axes  = cell(1,Num_diff_plots);
                                   hand_plots.data.hand_plots = cell(1,Num_diff_plots);

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
                                               
                                               %   W = .8;
                                               %   H = .9;
                                                
                                               hand_plots.data.hand_figs{1,w}  = figure('Color','white','units', 'normalized','Position',[.1 0.5 W H],'Name',name,'MenuBar', 'none','ToolBar', 'none');   
                                               hand_plots.data.hand_axes{1,w}  = cell(lines_pres,cols_pres);  
                                               hand_plots.data.hand_plots{1,w} = cell(lines_pres,cols_pres);  

                                              
                                               
                                                     for i = 1:cols_pres
                                                       for j = 1: lines_pres
                                                            [ left0   bottom0  width0  height0]   = Dimensionate_frame(zeros(lines_pres,cols_pres),j,i);   
                                                             hand_plots.data.hand_axes{1,w}{j,i}  = axes('position',[ (left0+ width0/5)   (bottom0-1.5*height0/5) width0*.8  height0*.8],'units', 'normalized');   
                                                       end
                                                     end
                                     end
                            %  uicontrol('Style','text','Units','pixels','units', 'normalized','Position',[.01 (.7) width0*3/4 height0/3], 'String',name);
                               end 
                                
  
                               for w = 1 : Num_diff_plots

                                     ind_data    =  Plots_index{1,w};
                                    lines_pres   = size(All_info.data(ind_data(1)).Index,1);
                                    cols_pres    = size(All_info.data(ind_data(1)).Index,2);
 
                                    hand_plots.data.hand_figs{1,w}; 
 
                                         for i = 1:cols_pres
                                           for j = 1: lines_pres
                                                    indXX = [];
                                                 for zer  = 1:length(Plots_index{1,w})
                                                    indXX = [indXX;  All_info.data(Plots_index{1,w}(zer)).Index(j,i)];
                                                 end
                                                 
                                                if length(indXX)
                                                     h_temp =   hand_plots.data.hand_axes{1,w}{j,i};    
                                                         if   indXX(1)
                                                              plot(h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(1))),'Color',All_info.data(Plots_index{1,w}(1)).Color);  % if the index is not zero !!     
                                                         end
                                                          if length(indXX) >1
                                                                    hold( h_temp, 'on' )
                                                                       for uer = 2:length(indXX)
                                                                           if indXX(uer)
                                                                              plot( h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(uer))),'Color',All_info.data(Plots_index{1,w}(uer)).Color)
                                                                           end 
                                                                       end  
                                                                    hold( h_temp, 'off' )
                                                          end 
                                                                    if prod((indXX  == 0))
                                                                        h_temp.Visible = 'off';
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
  
                     txt_count_clu.String = num2str(Clu_count.data);
                     txt_min_clu.String   = '1';
                     txt_max_clu.String   = num2str(size(All_data.data.Resp,1));
                end
          end
        
         
        
        function Prev(object_handle, event,All_data, All_info, hand_plots,Clu_count, txt_count_clu,txt_min_clu,txt_max_clu, Range_plots)
         
        act = Clu_count.data;
            if (act-1 ~= 0)
                Clu_count.data        = Clu_count.data - 1;
                txt_count_clu.String  = num2str(Clu_count.data);

                Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots) ;

            end  
        end
        
         function Next(object_handle, event,All_data, All_info, hand_plots,Clu_count, txt_count_clu,txt_min_clu,txt_max_clu,Range_plots)
         
        act = Clu_count.data;
        
            if length(All_data.data)
                Num_max_clu = size(All_data.data.Resp,1);

                  if (act+1 <= Num_max_clu)
                      Clu_count.data        = Clu_count.data + 1;
                      txt_count_clu.String  = num2str(Clu_count.data);
                     
                      Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots) ;
               
                 end 
            end
        
        
         end
        
            function Set_cluster_num(object_handle, event, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu,txt_max_clu,Range_plots)
         
               a = str2num(get(object_handle,'String'));
               if (~strcmp(txt_min_clu.String,''))&&(~strcmp(txt_max_clu.String,''))

                   if (a >= str2num(txt_min_clu.String))&&(a <= str2num(txt_max_clu.String))
                          Clu_count.data        = a; 
                          txt_count_clu.String  = num2str(a);
                          Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots) ;
                          object_handle.String  = '';
                   else
                      msgbox('Please enter a valid cluster number !')    
                   end
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
        
         
        function Close_Plots(object_handle, event, hand_plots,Clu_count,txt_count_clu)
        
        if length(hand_plots.data)
           for w = 1 : length(hand_plots.data.hand_figs)
                 htemp = hand_plots.data.hand_figs{1,w};
                 close(htemp)
           end
        end
             Clu_count.data       =  1;
             txt_count_clu.String = '1';
             
             
             hand_plots.data      = []; % Tue les pointeurs, il faut replotter les figures... 
             
        end