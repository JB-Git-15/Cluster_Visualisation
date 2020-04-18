%%%%%%%%%%%%%%%%%%% Clusters homogeneity

 Num_min_c   = 10;   % This constant states the minimum number of cells that a cluster has, it has to be lower or equal to 10

 h_act_clu   = Passage_par_ref(1);
 Range_plt_t = Passage_par_ref(30);     % 30 s is the default range of observation in time            
 Range_plt_y = Passage_par_ref(1);                

 h_num_cells = Passage_par_ref((1:Num_min_c)');
 
 dimS        =  get(0,'ScreenSize');  
 h_clu_hom   =  figure('Color','white','Position',dimS,'Name','Clustering homogeneity ','MenuBar', 'figure','ToolBar', 'auto');  %  'WindowStyle','modal'

 h_main_plot =  axes('position',[.1 .17 .8 .6 ],'units', 'normalized'); % plots-clust and some responses:    
 
 txt_min_clu = uicontrol('Style','text','units', 'normalized','position', [0.05  0.9  0.03 0.04],'String','1');
 txt_max_clu = uicontrol('Style','text','units', 'normalized','position', [0.23  0.9  0.03 0.04],'String',num2str(size(h_Liste_cells_cluster.data,1)));
 txt_act_clu = uicontrol('Style','text','units', 'normalized','position', [0.14  0.85 0.03 0.04],'String','1');
         
 slider_time = uicontrol('Style','Slider','units', 'normalized','position', [0.1  0.05 0.8 0.04],'Value',0,'callback',{@Slider_change,Range_plt_t, h_Clusters, h_Raw_data.data.dt, h_main_plot, h_act_clu,Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});
                                                                                                                                                                                                                                                                                                        
 butt_prev   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1  0.9 0.05 0.04],'String','<-', 'callback',{@Prev_clust,txt_max_clu,h_act_clu, h_main_plot,  h_Clusters,  h_Raw_data.data.dt,txt_act_clu,Range_plt_y,Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});
 butt_next   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.17  0.9 0.05 0.04],'String','->','callback',{@Next_clust,txt_max_clu,h_act_clu, h_main_plot,  h_Clusters,  h_Raw_data.data.dt,txt_act_clu,Range_plt_y,Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});
                                                                                                                                                                           
 butt_sample = uicontrol('Style','pushbutton','units', 'normalized','position', [0.3  0.85 0.1 0.09],'String','Sample responses','callback',{@Sample,h_act_clu, h_main_plot,  h_Clusters,  h_Raw_data.data.dt,txt_act_clu,Range_plt_y,Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});
                                                                                                                                                 
 %txt_norm    = uicontrol('Style','text','units', 'normalized','position', [0.45  0.85 0.08 0.04],'String','Normalize');
 %check_norm  = uicontrol('style','checkbox','units','normalized','position',[0.54  0.86 0.02 0.02],'string','','BackgroundColor',[1 1 1],'Value',0);

 txt_zoom_t  = uicontrol('Style','text','units', 'normalized','position', [0.59 0.85 0.1 0.04],'String','Zoom (t)');
 btt_plus_t  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.65  0.9 0.05 0.04],'String','+','callback',{@Plus_t, Range_plt_t, h_Clusters, h_Raw_data.data.dt, h_main_plot, h_act_clu,slider_time,Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});    % All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});       
 btt_min_t   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.58  0.9 0.05 0.04],'String','-','callback',{@Minus_t,Range_plt_t, h_Clusters, h_Raw_data.data.dt, h_main_plot, h_act_clu,slider_time,Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});    %,'callback',{@Minus_range, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});
  
 txt_zoom_y  = uicontrol('Style','text','units', 'normalized','position', [0.75 0.85 0.1 0.04],'String','Zoom (y)');
 btt_plus_y  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.81  0.9 0.05 0.04],'String','+','callback',{@Plus_y,  Range_plt_y, h_Clusters, h_Raw_data.data.dt, h_main_plot,h_act_clu,slider_time,Range_plt_t,  h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c}); % ,'callback',{@Plus_range,  All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});       
 btt_min_y   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.74  0.9 0.05 0.04],'String','-','callback',{@Minus_y, Range_plt_y, h_Clusters, h_Raw_data.data.dt, h_main_plot,h_act_clu,slider_time,Range_plt_t,  h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c});
                                                                                                                                                  
 btt_close   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.92  0.4 0.05 0.06],'String','Close','callback',{@Close_hom, h_clu_hom}); %,'callback',{@Minus_range, All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots});
 
 
 %%%%%%%%%%%%%%%%%%%%%  First plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         n_clu          = h_act_clu.data;
         prop_slider    = get(slider_time,'Value');
          Col            = hsv(Num_min_c); 
          hold on
                       list_temp        = h_Liste_cells_cluster.data{n_clu};
                       list_temp        = list_temp(1:Num_min_c);
                       h_num_cells.data = list_temp;
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
          hold off
         Range_plt_y.data = max( Buff_Clust(h_act_clu.data,:));
         ylim([-.45*Range_plt_y.data Range_plt_y.data])
         xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
             
 
         % h_num_cells  h_Liste_cells_cluster h_Raw_data
         
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 

                                         
function Next_clust(object_handle, event,txt_max_clu, h_act_clu,h_main_plot,  h_Clusters,  dt,txt_act_clu,Range_plt_y, Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c)
 

         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         n_clu          = h_act_clu.data;
         prop_slider    = get(slider_time,'Value');

         
         if (n_clu + 1 <=  str2num(get(txt_max_clu,'String')))  
             
             cla(h_main_plot);

             n_clu           = n_clu + 1;
             h_act_clu.data  = h_act_clu.data + 1;  
             
             Col             = hsv(Num_min_c); 
             hold on
                       list_temp        = h_Liste_cells_cluster.data{n_clu};
                       list_temp        = list_temp(1:Num_min_c);
                       h_num_cells.data = list_temp;
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
                 
             Range_plt_y.data = max( Buff_Clust(h_act_clu.data,:));
             ylim([-.45*Range_plt_y.data Range_plt_y.data])
             xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
             
             
             set( txt_act_clu,'String',num2str(h_act_clu.data))
         end    
end

 function Prev_clust(object_handle, event,txt_max_clu,h_act_clu, h_main_plot,  h_Clusters, dt, txt_act_clu,Range_plt_y,Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c)
         
 
         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         n_clu          =  h_act_clu.data;
         
         prop_slider    = get(slider_time,'Value');

         if (n_clu - 1 >= 1) 
             
             cla(h_main_plot);
             n_clu           = n_clu - 1; 
             h_act_clu.data  = h_act_clu.data - 1;         
             
             Col             = hsv(Num_min_c); 
             hold on
                       list_temp        = h_Liste_cells_cluster.data{n_clu};
                       list_temp        = list_temp(1:Num_min_c);
                       h_num_cells.data = list_temp;
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
             
              set( txt_act_clu,'String',num2str(h_act_clu.data))

         end    
end






  function Close_hom(object_handle, event, h_clu_hom)   % close the figure
                 msgbox('If you are happy with the result save the results, otherwise choose another distance')    
                 close(h_clu_hom)
  end
        
 
  function Update_plot(h_main_plot, Resp, Stims, m2, M2,Nbefore, Nafter, N_from_init,dt,en_cours)
 
  end
  
  function Plus_t(object_handle, event, Range_plt_t, h_Clusters, dt, h_main_plot,h_act_clu,slider_time,Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c) 
          
         prop_slider    = get(slider_time,'Value');

         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         Mid_zoom_range = (prop_slider*time(end) + (prop_slider*time(end) + Range_plt_t.data))/2;

         Range_plt_t.data = Range_plt_t.data*.8;

         list_temp      =  h_num_cells.data ;
         Col            =  hsv(Num_min_c); 

            hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
             
              set(slider_time,'Value', (Mid_zoom_range- Range_plt_t.data/2)/time(end)); 

              New_mid_range =  (prop_slider*time(end) + (prop_slider*time(end) + Range_plt_t.data))/2;
              Delta         =  Mid_zoom_range- New_mid_range;
              xlim([(prop_slider*time(end) + Delta)  (prop_slider*time(end) + Range_plt_t.data + Delta) ])
   end 
  
    function Minus_t(object_handle, event, Range_plt_t, h_Clusters, dt, h_main_plot, h_act_clu, slider_time, Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data, Num_min_c) 
         
         prop_slider    = get(slider_time,'Value');
 
         Buff_Clust       = h_Clusters.data;
         Buff_Clust       = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time             = dt*((1:size(Buff_Clust,2))-1);    
         Mid_zoom_range   = (prop_slider*time(end) + (prop_slider*time(end) + Range_plt_t.data))/2;

         Range_plt_t.data = Range_plt_t.data*1.2;%min(Range_plt_t.data*1.2,time(end));
          
         list_temp        =  h_num_cells.data;
         Col              =  hsv(Num_min_c); 
         hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot, time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot, time, Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
         hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              set(slider_time,'Value', max(0,(Mid_zoom_range- Range_plt_t.data/2)/time(end))); 

              New_mid_range =  (prop_slider*time(end) + (prop_slider*time(end) + Range_plt_t.data))/2;
              Delta         =  Mid_zoom_range- New_mid_range;
              prop_slider   =  get(slider_time,'Value');

              if  (prop_slider*time(end) + Delta) < 0 
                  xlim([0 time(end)])
                  a                = 0;
                  b                = time(end);
                  Range_plt_t.data = time(end);
                  set(slider_time,'Value',0);
              else
                  a                = (prop_slider*time(end) + Delta);
                  b                = (Delta + min((prop_slider*time(end) + Range_plt_t.data),time(end)));
              end
               xlim([a  b])
               
    end 
  
  
  
  
 
  function Plus_y( object_handle, event, Range_plt_y, h_Clusters, dt, h_main_plot,h_act_clu,slider_time,Range_plt_t, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c) 
        
         prop_slider      = get(slider_time,'Value');
  
         Range_plt_y.data = Range_plt_y.data*.8;
        
       
         Buff_Clust       = h_Clusters.data;
         Buff_Clust       = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time             = dt*((1:size(Buff_Clust,2))-1);    
         
           list_temp      =  h_num_cells.data;
           Col            =  hsv(Num_min_c); 
           hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
         
  end
  
  function Minus_y(object_handle, event, Range_plt_y, h_Clusters, dt, h_main_plot,h_act_clu,slider_time,Range_plt_t, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c) 
        
         prop_slider      = get(slider_time,'Value');
         Range_plt_y.data = Range_plt_y.data*1.1;
        
       
         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         
         
         Col            =  hsv(Num_min_c); 
         list_temp      =  h_num_cells.data;
            hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time,Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
         
    
  end
  
  function Slider_change(object_handle, event,Range_plt_t, h_Clusters, dt, h_main_plot, h_act_clu,Range_plt_y, h_num_cells,  h_Liste_cells_cluster, h_Raw_data, Num_min_c)
  
         prop_slider    = get(object_handle,'Value');
        
         Buff_Clust     = h_Clusters.data;
         Buff_Clust     = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         time           = dt*((1:size(Buff_Clust,2))-1);    
         
         list_temp      = h_num_cells.data;
          
         Col            =  hsv(Num_min_c); 
            hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time, Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              if ((prop_slider*time(end) + Range_plt_t.data) < time(end))   
                  xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
              else
                  xlim([(time(end)-Range_plt_t.data)  time(end)])
              end
  end
  
   
  function  Sample(object_handle, event, h_act_clu, h_main_plot,  h_Clusters, dt,txt_act_clu,Range_plt_y,Range_plt_t,slider_time, h_num_cells,  h_Liste_cells_cluster, h_Raw_data,Num_min_c)
  
   cla(h_main_plot);

         prop_slider      = get(slider_time,'Value');
        
         Buff_Clust       = h_Clusters.data;
         Buff_Clust       = reshape(Buff_Clust,[size(Buff_Clust,1) size(Buff_Clust,2)*size(Buff_Clust,3)]);

         n_clu            = h_act_clu.data;
         
         list_temp        = h_Liste_cells_cluster.data{n_clu};
         perm_cells       = randperm(length(list_temp));
         list_temp        = list_temp(perm_cells(1:Num_min_c));
         h_num_cells.data = list_temp;
         
     
         time             = dt*((1:size(Buff_Clust,2))-1);    
         
         h_num_cells.data = list_temp;
          
         Col              =  hsv(Num_min_c); 
            hold on
                       for uu = 1 : Num_min_c
                           plot(h_main_plot,time, h_Raw_data.data.Buffer(list_temp(uu),:),'Color',Col(uu,:))
                       end    
                           plot(h_main_plot,time, Buff_Clust(h_act_clu.data,:),'k','LineWidth',1.4)
            hold off
              ylim([-.45*Range_plt_y.data Range_plt_y.data])
              if ((prop_slider*time(end) + Range_plt_t.data) < time(end))   
                  xlim([prop_slider*time(end)  (prop_slider*time(end) + Range_plt_t.data) ])
              else
                  xlim([(time(end)-Range_plt_t.data)  time(end)])
              end       
  end
  
 %                                                 
%                                                 % load cluster number
%                                                 % make a subselection of the cells
%                                                 % plot
%                                                 n_clust             =   str2double(get(handles.text3,'String'));
%                                                 
%                                                 liste_cells         =   Liste_cells_cluster{n_clust,1};
%                                                 num_of_cells        =   length(liste_cells);
% 
%                                                 if num_of_cells >= 10
%                                                    index  = randperm(num_of_cells);
%                                                    en_cours  = liste_cells(index(1:10));
%                                                 else 
%                                                    en_cours  = liste_cells; 
%                                                 end
%                                                 
%                                                 Resp         = reshape(Buffer,[size(Buffer,1), n_time ,n_stim]);
%                    
%                                                StructH =  Update_fancy_plot(StructH, Resp, Stims, m2, M2,Nbefore, Nafter, N_from_init,dt,en_cours);
%                                  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



