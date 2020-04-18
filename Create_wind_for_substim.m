
          h4         = figure('Color','white','units', 'normalized','Position',[.05 0.05 .9 .95],'Name',All_info.data(Num_fam).name ,'MenuBar', 'none','ToolBar', 'none','CloseRequestFcn',@Delete_h4); % ,'WindowStyle','modal');  

          temp       =  All_Stims_choosen_to_fit.data{1,Num_fam};
          [n1,n2]    = size(temp);

          Array_choose_stims_fam = cell(n1,n2);
          for j = 1 : n2    
                for u= 1: n1  
                         if temp(u,j)
                             [ left   bottom  width  height] = Dimensionate_frame(zeros(n1,n2),u,j);
                             str                             = [All_info.data(Num_fam).ylabs{u},', ',All_info.data(Num_fam).xlabs{j}];
                             Array_choose_stims_fam{u,j}     = uicontrol('style','checkbox','units','normalized','position',[left bottom width height],'BackgroundColor',[1 1 1],'Value',1,'string',str,'callback',{@Select_specific_stims,All_Stims_choosen_to_fit, Num_fam, All_info});
                         end
                end
         end     

         butt_Validate_and_close  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.8 0.05 0.15 0.06],'String','Validate and close ','callback',{@Validate_and_close,h4});  
         uiwait(h4)
  
          
         function  Select_specific_stims(object_handle, event,All_Stims_choosen_to_fit, Num_fam, All_info)
                      %%%%%  All_Stims_choosen_to_fit, Num_fam
                      
                       temp                    =  All_Stims_choosen_to_fit.data{1,Num_fam};
                       [n1,n2]                 =  size(temp);

                          Array_choose_stims = cell(n1,n2);
                          for j = 1 : n2    
                                for u= 1: n1  
                                         if temp(u,j)
                                             Array_choose_stims{u,j} = [All_info.data(Num_fam).ylabs{u},', ',All_info.data(Num_fam).xlabs{j}];
                                         end
                                end
                          end     
                          
                         Index_stim   =   find(strcmp(event.Source.String, Array_choose_stims));
                         if event.Source.Value 
                              All_Stims_choosen_to_fit.data{Num_fam}(Index_stim) = 2; 
                         else    
                              All_Stims_choosen_to_fit.data{Num_fam}(Index_stim) = 1;      %All_info.data(Num_fam).Index_stim;
                         end
                       %%%%% [All_info.data(Num_fam).ylabs{u},', ',All_info.data(Num_fam).xlabs{j}]
                      
         end

         function  Validate_and_close(object_handle, event, h4)
                         Delete_h4(h4);                           
         end                                 
         function Delete_h4(object_handle, event)
                         delete(object_handle)
         end

       
       
       
       
       

