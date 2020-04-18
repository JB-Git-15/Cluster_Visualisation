
if length(All_data.data)&&length(All_info.data)&&(get(list_mod,'Value')> 1)

    hC                           = figure('Color','white','units', 'normalized','Position',[.1 0.1 .4 .5],'Name','Load and fit model' );%,'MenuBar', 'none','ToolBar', 'none'); % ,'WindowStyle','modal');  
      
    Butt_close                   = uicontrol('style','pushbutton','units','normalized','string','Close','position',[.84 .05 .1 .06],'callback',{@Close_Eval_F, hC});
     
    Theta                        = Passage_par_ref(1); % threshold
    
    
N_Stim_max = 0;    
for uuu = 1: length(All_info.data)
         Mxx        = max(max(All_info.data(uuu).Index));
         N_Stim_max = max(Mxx, N_Stim_max); 
end
%%%%%%%%All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)

          N2                = N_Stim_max;
          
          Data_temp         = All_data.data.Resp;
          Data_temp         = Data_temp(:,:,1:N2);
          Mod               = All_models.data(get(list_mod,'Value')).Data_fit;  % Model
          
          dt                = All_data.data.dt;
          n_init            = round(All_info.data(1).t_bef_stim/dt);
          
          Data_temp         = Data_temp(:,n_init:end,:);
          Mod               = Mod(:,n_init:end,:);
                    
          Matrix_sq_diff    = nan(size(Data_temp,1), N2);
          Im_sq_diff        = zeros(size(Matrix_sq_diff,1),size(Matrix_sq_diff,2),3);   
          
          Vect_vals         = [];
          Vect_signal       = [];
          for num_clu = 1:size(Data_temp,1) % 1: length(All_models.data(get(list_mod,'Value')).Liste_clusters)
             for num_stim = 1:N2
                [Bool_plot_mod,index_mod, index_stim] =  Boolean_plot_model_index_clu(num_stim, num_clu, All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)); 
                 if Bool_plot_mod
                         data =  squeeze(Data_temp(num_clu,:,num_stim));
                         mod  =  squeeze(Mod(index_mod,:,index_stim));
                        %  mx_1 =  max(abs(data));
                        %  mx_2 =  max(abs(mod));  
                         temp_dist                        = mean(abs(data-mod));
                         Matrix_sq_diff(num_clu,num_stim) = temp_dist; 
                         Vect_vals                        = [Vect_vals;temp_dist];
                         
                         temp_sig                         = max(data);
                         Vect_signal                      = [Vect_signal;temp_sig(1)];
                  end
              end    
          end
          
                         Min_vals                         = min(Vect_vals);
                         Max_vals                         = max(Vect_signal);
          
                         Matrix_sq_diff                   = (Matrix_sq_diff-Min_vals)/(Max_vals - Min_vals);
          
          [Row_Inn, Col_Inn]             = find(~isnan(Matrix_sq_diff)); 
          
          for t = 1 : length(Row_Inn)
              Im_sq_diff(Row_Inn(t),Col_Inn(t),1)   = 1;
          end
          N_cols   = 80;
          Col      = zeros(size(Matrix_sq_diff));
 
          for u = 1: length(Row_Inn)
                Col(Row_Inn(u),Col_Inn(u)) =  Establish_col_01_scale(Matrix_sq_diff(Row_Inn(u),Col_Inn(u)),Theta.data, N_cols); %1 - Establish_col_01_scale(Matrix_sq_diff(Row_Inn(u),Col_Inn(u)),.5*Std_dif_referential(Row_Inn(u),Col_Inn(u)), N_cols); 
          end      
                
          for w = 1 :size(Row_Inn,1)
                Im_sq_diff(Row_Inn(w),Col_Inn(w),2) = Col(Row_Inn(w),Col_Inn(w));%Col(w);
                Im_sq_diff(Row_Inn(w),Col_Inn(w),3) = Col(Row_Inn(w),Col_Inn(w));%Col(w);
          end
              
        h_process_ax =  axes('Position',[.04 .2 .9 .75]);
        h_plot = imshow(Im_sq_diff);
                     xlabel('Stims');ylabel('Clusters'); 
                     axis on   
                     impixelinfo(h_process_ax);

                     
        Butt_get_clu  = uicontrol('style','pushbutton','units','normalized','string','Get cluster','position',[.84 .3 .14 .06],'callback',{@Get_clu, Im_sq_diff,h_plot, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models});
               
       slider_theta   = uicontrol('style','slider','units','normalized','position',[.84 .5 .05 .3],'Min',0.000001,'Max',1,'Value',1 ,'callback',{@Set_theta, Theta, h_process_ax, All_data, list_mod, All_info, All_models});
                                                                                                

else
     msgbox('load the data and the model you want to evaluate')
end
 
                                   

function Set_theta(object_handle, event, Theta, h_process_ax, All_data, list_mod, All_info, All_models)

   val        = get(object_handle,'Value');
   Theta.data = val;
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Replot
            N_Stim_max = 0;    
for uuu = 1: length(All_info.data)
         Mxx        = max(max(All_info.data(uuu).Index));
         N_Stim_max = max(Mxx, N_Stim_max); 
end
%%%%%%%% All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)

          N2                = N_Stim_max;
          
          Data_temp         = All_data.data.Resp;
          Data_temp         = Data_temp(:,:,1:N2);
          Mod               = All_models.data(get(list_mod,'Value')).Data_fit;  % Model
          
          dt                = All_data.data.dt;
          n_init            = round(All_info.data(1).t_bef_stim/dt);
          
          Data_temp         = Data_temp(:,n_init:end,:);
          Mod               = Mod(:,n_init:end,:);
                    
          Matrix_sq_diff    = nan(size(Data_temp,1), N2);
          Im_sq_diff        = zeros(size(Matrix_sq_diff,1),size(Matrix_sq_diff,2),3);   
          
          Vect_vals         = [];
          Vect_signal       = [];
          for num_clu = 1:size(Data_temp,1) % 1: length(All_models.data(get(list_mod,'Value')).Liste_clusters)
             for num_stim = 1:N2
                [Bool_plot_mod,index_mod, index_stim] =  Boolean_plot_model_index_clu(num_stim, num_clu, All_models.data(get(list_mod,'Value')).Ind_stims, All_models.data(get(list_mod,'Value')).Liste_clusters, (get(list_mod,'Value')> 1)); 
                 if Bool_plot_mod
                         data =  squeeze(Data_temp(num_clu,:,num_stim));
                         mod  =  squeeze(Mod(index_mod,:,index_stim));
                       
                         temp_dist                        = mean(abs(data-mod));
                         Matrix_sq_diff(num_clu,num_stim) = temp_dist; 
                         Vect_vals                        = [Vect_vals;temp_dist];
                         
                         temp_sig                         = max(data);
                         Vect_signal                      = [Vect_signal;temp_sig(1)];
                  end
              end    
          end
          
                         Min_vals                         = min(Vect_vals);
                         Max_vals                         = max(Vect_signal)*Theta.data;
          
                         Matrix_sq_diff                   = (Matrix_sq_diff - Min_vals)/(Max_vals - Min_vals);
          
          [Row_Inn, Col_Inn]             = find(~isnan(Matrix_sq_diff)); 
          
          for t = 1 : length(Row_Inn)
              Im_sq_diff(Row_Inn(t),Col_Inn(t),1)   = 1;
          end
          N_cols   = 80;
          Col      = zeros(size(Matrix_sq_diff));
 
          for u = 1: length(Row_Inn)
                 Col(Row_Inn(u),Col_Inn(u)) =  Establish_col_01_scale(Matrix_sq_diff(Row_Inn(u),Col_Inn(u)), Theta.data, N_cols); %1 - Establish_col_01_scale(Matrix_sq_diff(Row_Inn(u),Col_Inn(u)),.5*Std_dif_referential(Row_Inn(u),Col_Inn(u)), N_cols); 
          end      
                
          for w = 1 :size(Row_Inn,1)
                Im_sq_diff(Row_Inn(w),Col_Inn(w),2) = Col(Row_Inn(w),Col_Inn(w));%Col(w);
                Im_sq_diff(Row_Inn(w),Col_Inn(w),3) = Col(Row_Inn(w),Col_Inn(w));%Col(w);
          end
              
             h_process_ax;% =  axes('Position',[.04 .2 .9 .75]);
                    
             imshow(Im_sq_diff);
                     xlabel('Stims');ylabel('Clusters'); 
                     axis on   
                     impixelinfo(h_process_ax);
 
          
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
end

 
function Close_Eval_F(object_handle, event, hC)
         delete(hC);                           
end  

 
   
  function col  = Establish_col_01_scale(x,Theta, N_cols) 
  
               col      = zeros(size(x));
               L        = linspace(0,1,N_cols);
               
             for uu = 1: length(x)  
                   y        = Ramp(x , Theta); % 1 - (1/2)*(1+erf((x(uu)-std_data)/std_data));
                  [val,ind] = sort((L -y).^2);
                   col(uu)  = L(ind(1));
             end  
  end
                

  function Get_clu(object_handle, event,Im_sq_diff,h_plot, All_data, All_info, hand_plots, Clu_count, txt_count_clu, txt_min_clu, txt_max_clu, Range_plots,check_square,list_Annots,txt_act_numC,list_mod, All_models)
      %set(h_plot,'ButtonDownFcn',@ImageClickCallback);
      [x,y] = ginput(1);
      n_stim = round(x);
      n_clu  = round(y);
      
      if Clu_count.data
                  if (n_clu <= size(Im_sq_diff,1))&&(n_clu >= 1)&&(n_stim <= size(Im_sq_diff,2))&&(n_stim >=1) 
                      set(list_Annots,'Value',1)
                      Clu_count.data        = n_clu;
                      txt_count_clu.String  = num2str(Clu_count.data);
                      Plot_Data2(All_data, All_info, hand_plots,Clu_count,txt_count_clu,txt_min_clu,txt_max_clu,Range_plots,check_square,txt_act_numC,list_mod, All_models);
                  end
      else
          msgbox('First plot the data')
      end
  end
   
  function y = Ramp(x, theta)
  
  [n_dim_1,n_dim_2] = size(x);
   y                = nan(size(x));
  
      for u = 1: n_dim_1
          for v= 1:n_dim_2
               if x(n_dim_1,n_dim_2) < 0
                    y(n_dim_1,n_dim_2) = 0; 
               elseif x(n_dim_1,n_dim_2) > theta
                    y(n_dim_1,n_dim_2) = 1; 
               else    
                    y(n_dim_1,n_dim_2) = x(n_dim_1,n_dim_2)/theta; 
               end    
          end
      end    
  
  end
  
  
  
  
  
  
  
