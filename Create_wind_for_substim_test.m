  h7         = figure('Color','white','units', 'normalized','Position',[.05 0.05 .9 .95],'Name',All_info.data(Num_fam).name ,'MenuBar', 'none','ToolBar', 'none','CloseRequestFcn',@Delete_h7); % ,'WindowStyle','modal');  

          temp       =  All_Stims_choosen_to_fit.data{1,Num_fam};
          [n1,n2]    = size(temp);

          Array_choose_stims_fam = cell(n1,n2);
           for j = 1 : n2    
                for u= 1: n1  
                         if temp(u,j)
                              [ left   bottom  width  height]        = Dimensionate_frame(zeros(n1,n2),u,j);
                                        Bool_select                  =  (All_Stims_choosen_to_fit.data{1,Num_fam}(u,j) == 2); 
                                       if Bool_select
                                          Colr = [0 1 0]; 
                                       else
                                          Colr = [1 1 1];
                                       end 
                                       str                           = [All_info.data(Num_fam).ylabs{u},', ',All_info.data(Num_fam).xlabs{j}];
                                       Array_choose_stims_fam{u,j}   =  uicontrol('style','checkbox','units','normalized','position',[ left   bottom  width  height],'BackgroundColor',Colr,'Value',1,'string',str,'callback',{@Select_specific_stims, All_Stims_choosen_to_fit, Num_fam, All_info,All_Stims_choosen_to_test});
                                       
                                       All_Stims_choosen_to_test.data{Num_fam}(u,j) = 2;  % I initialize everithing at 1...
                         end
                end
           end     

         butt_Validate_and_close  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.85 0.02 0.1 0.05],'String','Validate and close ','callback',{@Validate_and_close,h7});  
         uiwait(h7)
  
          function  Select_specific_stims(object_handle, event, All_Stims_choosen_to_fit, Num_fam, All_info,All_Stims_choosen_to_test)
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
                              All_Stims_choosen_to_test.data{Num_fam}(Index_stim) = 2; 
                         else    
                              All_Stims_choosen_to_test.data{Num_fam}(Index_stim) = 1;      %All_info.data(Num_fam).Index_stim;
                         end
                       %%%%% [All_info.data(Num_fam).ylabs{u},', ',All_info.data(Num_fam).xlabs{j}]
                      
         end

         function  Validate_and_close(object_handle, event, h7)
                         Delete_h7(h7);                           
         end                                 
         function Delete_h7(object_handle, event)
                         delete(object_handle)
         end

       
       
       
       