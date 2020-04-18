function   Liste_c_cluster  = Donne_liste(tree, num_cluster, Liste_clusters_ok_liste_c) %  Donne toutes les cellules qui appartiennent au cluster...

   Num_cells  = size(tree,1) + 1;   
   Liste_temp = [];

   if size(tree,2) == 3    
       tree  = [tree, (1+Num_cells: (size(tree,1) + Num_cells))' ];
   end    

   
   if ( num_cluster <= Num_cells) 
      Liste_c_cluster = num_cluster;
   else
     
       
   row        = find(tree(:,4) == num_cluster);
   cl1        = tree(row,1);
   cl2        = tree(row,2);

   if  ( cl1 <= Num_cells)   
       Liste_temp = [Liste_temp; cl1];
   else
       Liste_temp = [Liste_temp; Donne_liste(tree, cl1)];
   end
   
   if  ( cl2 <= Num_cells)   
       Liste_temp = [Liste_temp; cl2];
   else
       Liste_temp = [Liste_temp; Donne_liste(tree, cl2)];
   end
       Liste_c_cluster =  Liste_temp;
   end
   
end




