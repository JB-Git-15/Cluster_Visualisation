

     h3                          = figure('Color','white','units', 'normalized','Position',[.1 0.1 .8 .6],'Name','Choose stims to fit' ,'MenuBar', 'none','ToolBar', 'none','CloseRequestFcn',@Delete_h); % ,'WindowStyle','modal');  

     if prod(cellfun(@isempty, All_Stims_choosen_to_fit.data))
         for uio = 1: size(All_info.data,2)
               All_Stims_choosen_to_fit.data{1,uio} = double(~(~(All_info.data(uio).Index)));   %  a priori the ones which are stims (1), are not chosen...
         end
     end
     
     Num_fam_ind                 = length(All_info.data);
     N1                          = round(Num_fam_ind/round(sqrt(Num_fam_ind)));
     N2                          = round(Num_fam_ind/N1);
      if Num_fam_ind -N1*N2 > 0 
            N2 = N2 + 1;
      end  
          Array_choose_stims_fam = cell(N1,N2);
          Array_text_stims_fam   = cell(N1,N2);
          count = 1;
         
         for j = 1 : N2    
              for u= 1: N1  
                  [ left   bottom  width  height] = Dimensionate_frame(zeros(N1,N2),u,j);
                    if (count <= length(All_info.data)) 
                       %%%% 
                          Family_present            = ~(~length(find(All_Stims_choosen_to_fit.data{1,count} == 2)));                      
                       %%%% 
                       Array_choose_stims_fam{u,j}  = uicontrol('style','checkbox','units','normalized','position',[ (.01 + left*.5) (bottom*.5 + .2)   width*.5 height*.2],'BackgroundColor',[1 1 1],'Value', Family_present,'string',All_info.data(count).name,'callback',{@Identify_and_open,All_info,N1,N2, All_Stims_choosen_to_fit});
                       count                        = count + 1;
                    end
              end
         end     

       butt_Validate_and_close  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.75 0.8 0.2 0.08],'String','Validate and close ','callback',{@Validate_and_close,h3});  
 
       uiwait(h3)

       function  Identify_and_open(object_handle, event, All_info,N1,N2,All_Stims_choosen_to_fit)
      
        temp = {};
            for uu = 1: size(All_info.data,2)
              temp{uu,1} = All_info.data(uu).name;
            end
                 Num_fam = find(strcmp(event.Source.String,temp));
                 
                 if object_handle.Value
                    temp                                    = All_Stims_choosen_to_fit.data{1,Num_fam};
                    Ind_ones                                = find(temp);
                    temp(Ind_ones)                          = 2;                   % 2 = selected, here all selected
                    All_Stims_choosen_to_fit.data{1,Num_fam}= temp;
                    Create_wind_for_substim;
                    
                    if ~length(find(All_Stims_choosen_to_fit.data{Num_fam} == 2))
                         object_handle.Value  = 0;
                    end  
                 else
                    temp                                    = All_Stims_choosen_to_fit.data{1,Num_fam};
                    Ind_ones                                = find(temp);
                    temp(Ind_ones)                          = 1;                   % 1 =  non selected, here all unselected (0 = no stim)
                    All_Stims_choosen_to_fit.data{1,Num_fam}= temp;
                 end
                 
       end
      
                                     
     function  Validate_and_close(object_handle, event, h3)
                 Delete_h(h3);                           
     end                                 
     function Delete_h(object_handle, event)
                 delete(object_handle)
     end

 
