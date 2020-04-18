%%%%%%%%%%%%%%%%%%%%%%%%%% Fuse stims %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       




 dimS          =  get(0,'ScreenSize');  
 h_Figure_fuse =  figure('Color','white','Position',[dimS(1) dimS(2) dimS(3)/2 dimS(4)],'Name',[' Choose stimulus that should be displayed together  '],'WindowStyle','modal','MenuBar', 'none','ToolBar', 'none');
 
 
 if length(All_info.data)
    for uvc = 1 :size(All_info.data,2)  
        Lcell{uvc}       = All_info.data(uvc).name;   
    end
 end
    
 
 temp_list_R     = Passage_par_ref(Lcell);
 

 Rcell           = ''; 
 liste21         = uicontrol('Style', 'listbox','units', 'normalized','position', [0.55 0.3 0.3 0.6],'string', Rcell,'Callback',{@Disp_list2,All_info});

 liste11         = uicontrol('Style', 'listbox','units', 'normalized','position', [0.15 0.3 0.3 0.6],'string', Lcell,'Callback',{@Disp_list1,All_info,liste21});
 
 
  but_ok         = uicontrol('style', 'pushbutton','string', 'Ok',...
                                         'units', 'normalized','position', [0.15 0.05 0.2 0.05],'callback',{@Validation,All_info, h_Figure_fuse,liste21,liste11});%
      
  but_cancel     = uicontrol('style', 'pushbutton','string', 'Cancel',...
                                         'units', 'normalized','position', [0.55  0.05 0.2 0.05],'callback',{@Cancel, h_Figure_fuse});%
                                   
                                     
   text1        = uicontrol('Style', 'text','units', 'normalized','position', [0.2 0.9 0.2 0.05],'string', 'Available classes','backgroundcolor','white');
   text2        = uicontrol('Style', 'text','units', 'normalized','position', [0.6 0.9 0.2 0.05],'string', 'Selected  classes','backgroundcolor','white');
                               
                                     
                                     
                                     
                                     
  %l = liste11;                                   
                                     
 
 
function Disp_list1(object_handle, event,All_info,liste21)
 
 
       items          = get(object_handle,'String');
       index_selected = get(object_handle,'Value');
       item_selected  = items{index_selected};
       
  
        set(object_handle,'Value',1)
       
      temp            = get(liste21,'String');
      n               = length(temp); 
      temp{n+1}       = item_selected;

  
      
      
      set(liste21,'Value',1)

      set(liste21,'String',temp)
      
      
   items(index_selected)        = [];
   set(object_handle,'String',items); 
  
  
  
end
 
 
function Disp_list2(object_handle, event,All_info)
 
 
       items          = get(object_handle,'String');
       index_selected = get(object_handle,'Value');
       item_selected  = items{index_selected};
       
       
       set(object_handle,'Value',1)

       
        items(index_selected)        = [];
        set(object_handle,'String',items); 
  
        
   
 
end
 
function Validation(object_handle, event, All_info, h_Figure_fuse,liste21,liste11)
  
 items          = get(liste21,'String');

 if length(items) > 1  
   
   
   all_dimensions_equal = 1; % Start with this boolean true..


    Dimensions          = zeros(length(items),2);       % lines, cols for each item, and Fusion index
    Index_in_All_info   = zeros(length(items),1);
    
        for uuu = 1:length(items) 
                for vv = 1:size(All_info.data,2)
                     if strcmp(All_info.data(vv).name, items{uuu})
                           Dimensions(uuu,1)      = size(All_info.data(vv).Index,1);
                           Dimensions(uuu,2)      = size(All_info.data(vv).Index,2);
                           Index_in_All_info(uuu) = vv;
                      end
                end
        end
    
        for p = 2:size(Dimensions,1)
              all_dimensions_equal = all_dimensions_equal*(Dimensions(1,1) == Dimensions(p,1))*(Dimensions(1,2) == Dimensions(p,2));
        end
        
        if all_dimensions_equal
        
        

                Fus_ind=  [];
                for w = 1:size( All_info.data,2)
                  Fus_ind = [Fus_ind; All_info.data(w).Fusi_Ind];   
                end
                  Max_Fus_ind  = max(Fus_ind);


                  for r = 1 : length(items)
                        All_info.data(Index_in_All_info(r)).Fusi_Ind = Max_Fus_ind + 1;
                  end

                  x= '';
                  while length(x) == 0
                      x = inputdlg({'Name of the joint stimulus category'},...
                               'New joint category', [1 50]);
                  end
                  for g = 1:length(items)
                       All_info.data(Index_in_All_info(g)).Comm_nam =  x{1};
                  end    
                  
                  for g = 1:length(items)
                        c         = 0;
                        name_stim = All_info.data(Index_in_All_info(g)).name;
                      while length(c) < 3
                        c = uisetcolor([0 0 1],['Color of ', name_stim]);
                      end
                       All_info.data(Index_in_All_info(g)).Color = c;
                  end
                  
        else
           msgbox('The dimensions of the family of stims are not equal, we can''t plot them together! ') 
            
        end    
            
            
 % Check whether the chosen stims have the same dimensions
 
 %  Change the names of the main list add a index
 %  Change the  temp_struct.Fusi_Ind= 0;  % This parameter states that this stimulus is not fused with another one
 %  Ask for the name of the title of the display in which the selected stims will appear                         
 
 
 %  temp_struct.Comm_nam= '';

 else
     msgbox('There is only one stimulus in the right list, choose another one ! ')
     
     
 end
 
  
 
   close(h_Figure_fuse)
end

function Cancel(object_handle, envent, h_Figure_fuse)

  close(h_Figure_fuse);
 
end
 
 









  








