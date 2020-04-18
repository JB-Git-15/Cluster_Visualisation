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