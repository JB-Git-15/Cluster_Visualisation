 function Plot_Data2(All_data, All_info, hand_plots, Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models)    % Is the same as plot, exept that handles and events are not arguments
             if Clu_count.data
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
                            %  uicontrol('Style','text','Units','pixels','units', 'normalized','Position',[.01 (.7) width0*3/4 height0/3], 'String',name);
                               end 
                               for w = 1 : Num_diff_plots
                                    ind_data     = Plots_index{1,w};
                                    lines_pres   = size(All_info.data(ind_data(1)).Index,1);
                                    cols_pres    = size(All_info.data(ind_data(1)).Index,2);
 
                                    hand_plots.data.hand_figs{1,w}; 
 
                                         for i = 1:cols_pres
                                           for j = 1: lines_pres
                                                    indXX  = [];
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
                                                     cla(h_temp);
                                                         if   indXX(1)
                                                             hold(h_temp,'on') 
                                                                plot(h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(1))),'Color',All_info.data(Plots_index{1,w}(1)).Color);  % if the index is not zero !!     
                                                                plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g') 
                                                              if Bool_plot_mod
                                                                Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
                                                                plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(1))),'Color','k')      
                                                              end
                                                             hold(h_temp,'off') 
                                                         end
                                                          if length(indXX) >1
                                                                    hold( h_temp, 'on' )
                                                                       for uer = 2:length(indXX)
                                                                           if indXX(uer)
                                                                              plot( h_temp, time, squeeze(Resp(Clu_count.data, :, indXX(uer))),'Color',All_info.data(Plots_index{1,w}(uer)).Color)
                                                                              if Bool_plot_mod
                                                                                Mod  = All_models.data(get(list_mod,'Value')).Data_fit;
                                                                                plot(h_temp, time, squeeze(Mod(index_mod, :, index_stim(uer))),'Color','k')      
                                                                              end
                                                                           end 
                                                                       end  
                                                                              plot(h_temp, [t_stim   t_fin_stim],[-.3*Range_plots.data -.3*Range_plots.data],'g') 
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
                             STR    = '';

                              if length(All_data.data.Annotations{Clu_count.data,1})
                                      for uu= 1:size(All_data.data.Annotations{Clu_count.data,1},1)
                                             % n_class = All_data.data.Annotations{Clu_count.data,1}(uu,1);
                                             % n_sub_c = All_data.data.Annotations{Clu_count.data,1}(uu,2);
                                             % tmpx    = All_data.data.SubCats_Annotation{n_class,1};
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
                                 
                                 hand_plots.data.hand_figs{1,Num_diff_plots+2};     
                                 h_temp                          = hand_plots.data.hand_axes{1,Num_diff_plots+2};
                                 [az,el]                         = view(h_temp);
                                 cla(h_temp)
                                              plot3(h_temp,Spatial_info_other_cells(:,2),Spatial_info_other_cells(:,3),Spatial_info_other_cells(:,1) ,'.','Color',[.65 .65 .65])
                                         hold(h_temp,'on')
                                              plot3(h_temp,Spatial_info_cells(:,2),Spatial_info_cells(:,3),Spatial_info_cells(:,1),'.r','MarkerSize',10)
                                         hold(h_temp,'off')
                                              set(h_temp, 'ZDir', 'reverse'); 
                                              zlabel(h_temp,'Depth (µm)')
                                              view(h_temp,az,el);
                       end
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                end
             end
         end