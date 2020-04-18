function Update_main_figure(All_info,liste)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Update main figure :

n_stims = size(All_info,2);
text    = cell(1,n_stims);

if n_stims
   for ux = 1: n_stims
     temp_struct = All_info.data(1,ux);  
     text{1,ux}  = temp_struct.name;
   end
end

 set(liste,'String',text);  % update the listbox
 
 
end
