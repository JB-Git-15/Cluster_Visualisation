function Liste_cells_cluster  = Donne_liste_clusters_dmax(tree, d, N_cells, N_cells_max_per_clust)

%  Donne toutes les cellules qui appartiennent au cluster...
 

if size(tree,2) == 3
    
   tree  = [tree, (1+N_cells: (size(tree,1) + N_cells))' ];
     
end    


        l               = find(tree(:,3) <= d);
        Liste_c_cluster = []; %  cell(1,1);  
        Name            = [];
        
        if length(l)
            for u = 1: length(l)                                                     % u: indice de cluster du bas vers le haut de tree
                  Num_clust_temp =  tree(l(end-u+1),4);   
                          if length(Liste_c_cluster)                                 % Liste : cells( num clust,  liste cells)
                                   List_cells_temp = cell2mat(Liste_c_cluster);
                                   List_cells_temp = List_cells_temp(:);
                                   if sum(List_cells_temp == Num_clust_temp)         % si le cluster est dans la liste des cellules
                                           for w = 1 : size(Liste_c_cluster,1)
                                                 ind = find(Liste_c_cluster{w,:} ==  Num_clust_temp);
                                                 if length(ind)  
                                                     Liste_c_cluster{w,:}(ind) = [];
                                                     Liste_c_cluster{w,:}      = [Liste_c_cluster{w,:}; tree(l(end-u+1),1)  ; tree(l(end-u+1),2) ];
                                                 end
                                           end  
                                   else
                                                    Name                            = [Name; Num_clust_temp];
                                                    Liste_c_cluster                 = [Liste_c_cluster;cell(1,1)];
                                                    Liste_c_cluster{end,:}          = [Liste_c_cluster{end,:}; tree(l(end-u+1),1)  ; tree(l(end-u+1),2) ];       

                                   end   
                          else   % cree le cluster et rajoute la liste des cellules/ clusters
                                                    Name                            = [Name; Num_clust_temp];
                                                    Liste_c_cluster                 = [Liste_c_cluster;cell(1,1)];
                                                    Liste_c_cluster{end,:}          = [Liste_c_cluster{end,:}; tree(l(end-u+1),1)  ; tree(l(end-u+1),2) ];
                          end    
         end
     end

                         
                          Liste_cells_cluster           = cell(size(Liste_c_cluster));
                         
                          for zz = 1: size(Liste_c_cluster,1)
                                       list             =  Liste_c_cluster{zz,1};
                                       list_cells       =  [];  

                                       for rr = 1 : length(list)
                                            n_clust_temp = list(rr);
                                            list_cells   = [ list_cells  ; Donne_liste(tree, n_clust_temp)    ];
                                       end  
                                   
                               Liste_cells_cluster{zz,1} =  list_cells;
                          end
                          
 % Dernière étape: trie en fonction du nombre de cellules:                         
                          
                               Num_cell                  = zeros(length(Liste_cells_cluster),1);             
                               for ww = 1 : length(Liste_cells_cluster) 
                                    Num_cell(ww,1)       = length(Liste_cells_cluster{ww,1}); 
                               end
                                    [val, ind]           =  sort(Num_cell,'descend');
                               
                               Liste_cells_cluster       =  Liste_cells_cluster(ind);
               
         if  nargin == 4
           
                                    ind_more_than_N      = find(val > N_cells_max_per_clust);                     
                                   Liste_cells_cluster   = Liste_cells_cluster(ind_more_than_N);                    
         end                         

end
