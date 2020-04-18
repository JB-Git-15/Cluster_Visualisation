%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New class  of stimuli %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 
   Correct_input = 0;
   
   while Correct_input == 0
       
           info_stim = inputdlg({'Name','Lines','Columns'},...
                      'Families of stimuli', [1 50; 1 50; 1 50]); 
           if length(info_stim)      
                   Name      = info_stim{1};
                   lines     = str2num(info_stim{2});
                   cols      = str2num(info_stim{3});  
           else        
                 Name = '';
                 lines= '';
                 cols = '';
           end
           if (~strcmp(Name,''))&&(length(lines))&&(length(cols))
               Correct_input = 1;      
           end
   end
   
   h_Ind_Mat        = Passage_par_ref(zeros(lines,cols));
   h_Stim_length_Mat= Passage_par_ref(zeros(lines,cols));

   [L B W H]        = Dimensionate_frame(zeros(lines+1,cols+1),lines,cols);
   h_Diagonal_edit  = Passage_par_ref([L B W H]);
    
        dimS        =  get(0,'ScreenSize');  
        h_New_class =  figure('Color','white','Position',dimS,'Name',['Stimulus type : ', Name, ',   Enter the stimulus index: '],'WindowStyle','modal','MenuBar', 'none','ToolBar', 'none');   
       Array_num_s  =  cell(lines,cols);
      
       Array_y_text =  cell(1,lines);
       Array_x_text =  cell(1,cols);
       
       h_Arr_y_text = Passage_par_ref(cell(1,lines));
       h_Arr_x_text = Passage_par_ref(cell(1,cols));
          for w = 1:cols
             h_Arr_x_text.data{1,w} = 'time (s)';  
          end    
          for w = 1:lines
             h_Arr_y_text.data{1,w} = '';  
          end    
          
       for u= 1: lines  
         for j = 1 : cols
                 [ left   bottom  width  height] = Dimensionate_frame(zeros(lines+1,cols+1),u,j);   
                 Array_num_s{u,j}                = uicontrol('style','edit','string','0','Units','normalized','Position',[ left   bottom  width  height],'callback',{@Catchindices,h_Ind_Mat,h_Diagonal_edit});
         end
       end
        
       for j = 1: cols
            [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),lines,j);  

             h_temp            = axes('position',[ left0   (bottom0 - height0/4) width0  height0/4],'units', 'normalized');
             t                 = text(h_temp,0.5,0.5,'time (s)');
             Array_x_text{1,j} = t;
             axis off
              % Array_x_lab{1,j} =  uicontrol('style', 'text','string', 'time (s)',...
              %                     'units', 'normalized','position', [ left0   (bottom0 - height0/4) width0  height0/4],'backgroundcolor',[1 1 1]);%
       end    
       
              
       for j = 1: lines
            [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),j,1);   
             h_temp            = axes('position',[ (left0- width/5)   (bottom0) width0/5  height0],'units', 'normalized');
             t                 = text(h_temp,0.5,0.3,'','Rotation',90);
             Array_y_text{1,j} = t;
             axis off
       end   
       
       
       [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),lines+1,1);   

        but_change_y  = uicontrol('style', 'pushbutton','string', 'Set y labels',...
                                         'units', 'normalized','position',[ left0   bottom0  width0  height0/2],'callback',  {@Set_labels,Array_y_text,h_Arr_y_text});%
       
        [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),lines+1,2);   

        but_change_x  = uicontrol('style', 'pushbutton','string', 'Set x labels',...
                                         'units', 'normalized','position',[ left0   bottom0  width0  height0/2],'callback',  {@Set_labels,Array_x_text,h_Arr_x_text});%
       
                                     
                                     
        [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),1,cols+1);   

        but_validate  = uicontrol('style', 'pushbutton','string', 'Validate',...
                                         'units', 'normalized','position',[ left0   bottom0  width0  height0*.4],'BackgroundColor',[0 1 0], 'callback', {@Validation, h_Ind_Mat, h_Stim_length_Mat, h_Diagonal_edit,All_info,Name, h_Arr_x_text, h_Arr_y_text, h_New_class,liste,stim_Max_l, t_bef_stim, t_aft_stim});
                                                                                                                                                                       
         
         [ left0   bottom0  width0  height0] = Dimensionate_frame(zeros(lines+1,cols+1),1,cols+1);   

       % but_cancel  = uicontrol('style', 'pushbutton','string', 'Cancel',...
               %                          'units', 'normalized','position',[ left0   (bottom0 +height0*.5)   width0  height0*.4],'BackgroundColor',[1 0 0]);%
                                    
                                                                 
 function Set_labels(object_handle, event,Array_text,h_Arr_text)

    for uu = 1 : length(Array_text)
        t         = Array_text{1,uu};
        t. String = 'LABEL';
        t.Color   = [1 0 0];
        answer    = {};  
        
           while length(answer) == 0
            answer = inputdlg('Enter the name of the highlighted label',' ',1, {h_Arr_text.data{1,uu}});%, ...
            % 'Sample', [1 50]);
           end 
      
      t.String = answer{:};
      t.Color  = [0 0 0];
        
      h_Arr_text.data{1,uu} = answer{:};
    end  
end     
 
function Catchindices(object_handle, event,h_Ind_Mat,h_Diagonal_edit) 

Stringg = get(object_handle,'String');

   if prod(isstrprop(Stringg,'digit'))  % check that it is a number !!
                   number = str2num(Stringg);
                   if  (floor(number)== number)&&(number > 0)   % verify that it is a positive integer
                      [line,column]                = Invert_coordinates(object_handle.Position, h_Diagonal_edit.data);   % h_Diagonal_edit.data : gives the position of the editbox at the corner line,col
                       h_Ind_Mat.data(line,column) = number;
                       %disp(h_Ind_Mat.data)
                   else
                       set(object_handle,'String','0');
                       msgbox('The stimulus index must be an integer');   
                   end    
   else
        msgbox('The stimulus index must be a number (an integer)');   
        set(object_handle,'String','0');

   end    
end
 
     
function Validation(object_handle, event,h_Ind_Mat,h_Stim_length_Mat,h_Diagonal_edit, All_info,Name,h_Arr_x_text, h_Arr_y_text,h_New_class,liste,stim_Max_l,t_bef_stim, t_aft_stim)

if length( find(h_Ind_Mat.data(:)))
        ok = 0 ;
             while ok == 0
                        choice = questdlg('', ...
                            'Seeting the stimulus time length', ...
                            'Specify individually the time lengths','Specify the time length common to all stims','Specify the time length common to all stims');
                        % Handle response
                        switch choice
                            case 'Specify individually the time lengths'
                                
                                   % Create a figure in which we can set
                                   % individually the time lengths of the
                                   % stim :
                                  Specify_time_lengths;     

                                        Index_nn     =  find(h_Ind_Mat.data);  
                                        if prod(h_Stim_length_Mat.data(Index_nn))   
                                            ok       = 1;
                                        end 
                            case 'Specify the time length common to all stims'
                                        prompt     = {'Time lenght of all present stimulus in this category (seconds)'};
                                        name       = 'Stim time length';
                                        defaultans = {'0.5'};
                                        answer     = inputdlg(prompt,name,[1 40],defaultans);
                                        if length(answer)  
                                            if isnumeric(str2num(answer{:})) %  prod(isstrprop(answer{1,1},'digit'))
                                               h_Stim_length_Mat.data =  double(logical(h_Ind_Mat.data))*str2double(answer);
                                               ok = 1;
                                            end 
                                        end
                        end
                        if (ok == 1)
                                 %%%%%%%%%       Specify the color 
                                     c = uisetcolor([0 0 1],['Color of ', Name]);
                                     if c == 0
                                        Col = [ 0 0 1]; 
                                     else
                                        Col = c; 
                                     end
                                 %%%%%%%%%%      Validate and store the data
                                     temp_struct            = struct;
                                     temp_struct.name       = Name;
                                     temp_struct.xlabs      = h_Arr_x_text.data;
                                     temp_struct.ylabs      = h_Arr_y_text.data;
                                     temp_struct.Index      = h_Ind_Mat.data;
                                     temp_struct.Stim_len   = h_Stim_length_Mat.data;
                                     temp_struct.Fusi_Ind   = 0;  % This parameter states that this stimulus is not fused with another one
                                     temp_struct.Comm_nam   = ''; % This parameter is used for example when I need to pu the tiltle chirp to a plot in which there are two stims: chirp up/down 
                                     temp_struct.Color      = Col;  % By default, the plots will be blue...
                                     temp_struct.t_bef_stim = str2num(get(t_bef_stim,'String'));
                                     temp_struct.t_aft_stim = str2num(get(t_aft_stim,'String'));
                                     temp_struct.stim_Max_l = -1;

                                     All_info.data          = [All_info.data, temp_struct];
                                    %%%%%%%%%%%%%%%%%%%% Update main figure
                                    n_stims         = size(All_info.data,2);
                                    text            = cell(1,n_stims);
                                    Max_stim_length = -1;

                                    if n_stims
                                       for ux = 1: n_stims
                                         temp_struct      = All_info.data(1,ux);  
                                         text{1,ux}       = temp_struct.name;
                                         Max_stim_length  = max(Max_stim_length,max(max(temp_struct.Stim_len)));
                                       end
                                    end
                                     set(liste,'String',text);  % update the listbox
                                     set(stim_Max_l,'String',num2str(Max_stim_length)); % update the value of the maximal stimulus length
                                     close(h_New_class); % close the figure
                         end
             end            
 else
                  msgbox('There are no indices, to abort press Cancel');       
end    
        
end










  
 