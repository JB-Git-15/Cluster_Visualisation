%%%%%% Specify individually time lengths

      
                                            lines       = size(h_Ind_Mat.data,1);
                                            cols        = size(h_Ind_Mat.data,2);
                                    
                                            dimS        =  get(0,'ScreenSize');  
                                            h2          =  figure('Color','white','Position',dimS,'Name', 'Specify stimulus time lengths: ','WindowStyle','modal','Visible','on','MenuBar', 'none','ToolBar', 'none','CloseRequestFcn' ,@doDelete);   
                                    Array_time_lengths  =  cell(lines,cols);

                                              
                                           for u= 1: lines  
                                             for j = 1 : cols

                                                 if h_Ind_Mat.data(u,j)
                                                 
                                                     [ left   bottom  width  height] = Dimensionate_frame(zeros(lines+1,cols+1),u,j);   
                                                     Array_time_lengths{u,j}         = uicontrol('style','edit','string','0','Units','normalized','Position',[ left   bottom  width  height],'callback',{@Catch_times,h_Stim_length_Mat,h_Diagonal_edit});
                                                
                                                      t                              = uicontrol('style','text','string',num2str(h_Ind_Mat.data(u,j)),'Units','normalized','Position',[ (left + width*3/4) (bottom-height/5)  width/4  height/5]);
                                                 else
                                                      
                                                      
                                                 end
                                             end
                                           end
                           
                                             [ left   bottom  width  height] = Dimensionate_frame(zeros(lines+1,cols+1), lines+1,cols+1);   
                                              but_ok                                  = uicontrol('style', 'pushbutton','string', 'Ok',...
                                         'units', 'normalized','position',[ left   bottom  width  height],'callback',{@Validate_and_close_times,h_Ind_Mat,h_Stim_length_Mat,h2}); 
                                              uiwait(h2)     
% movegui(h2)
% set(h2 ,'WindowStyle','modal','Visible','on');
% drawnow;

                                      
function Catch_times(object_handle, event,h_Stim_length_Mat,h_Diagonal_edit) 

  Stringg = get(object_handle,'String');
  number = str2num(Stringg);
           if isnumeric(number)&&(number > 0)     % check that it is a positive number !!
                               [line,column]                        = Invert_coordinates(object_handle.Position, h_Diagonal_edit.data);   % h_Diagonal_edit.data : gives the position of the editbox at the corner line,col
                               h_Stim_length_Mat.data(line,column)  = number;
                              % disp(h_Stim_length_Mat.data)
          else
                               msgbox('The stimulus index must be a positive real number');   
                               set(object_handle,'String','0');
          end    
end    
                                    
                                    
                                    
function  Validate_and_close_times(object_handle, event,h_Ind_Mat,h_Stim_length_Mat,h2)
    Non_nil_indices = find( h_Ind_Mat.data);

    if prod(logical(h_Stim_length_Mat.data(Non_nil_indices))) % if all the indices are filled
             doDelete(h2);                           
    else
         msgbox('All the fields must be filled')         
    end                                                
end                                 
                                    
                                
                                    
    function doDelete(object_handle, event)
           delete(object_handle);
    end                                 
