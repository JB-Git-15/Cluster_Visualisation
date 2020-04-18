function [Plot_mod, Ind_clu_model, Ind_stim] =  Boolean_plot_model_index_clu(Index_actual_plot, number_act_cluster, Liste_Ind_stimulus_model, Liste_clusters_model, Is_model)  


N_act = length(Index_actual_plot);

    if N_act
        temp     = zeros(N_act,1);
        Ind_stim = zeros(N_act,1);
          for uu = 1: N_act
                  temp(uu,1)      = length(find(Index_actual_plot(uu) == Liste_Ind_stimulus_model));
                  if temp(uu,1)
                      temp2           = find(Index_actual_plot(uu) == Liste_Ind_stimulus_model);                 
                      Ind_stim(uu,1)  = temp2(1);
                  end
          end    
    end    
  
b              = prod(temp);
c              = length(find(number_act_cluster == Liste_clusters_model));
d              = Is_model; % This variable check whather the user selected a model.

Plot_mod       = b*c*d;
Ind_clu_model  = find(number_act_cluster == Liste_clusters_model);

end