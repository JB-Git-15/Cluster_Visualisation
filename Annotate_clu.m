%%%%%%% Annotate clu


%function Annotate_clu(All_data,Clu_count)


if Clu_count.data
      dimS      = get(0,'ScreenSize');  
      hC        = figure('Color','white','units', 'normalized','Position',[.1 0 .7 .6],'Name',['Annotate the cluster # ',num2str(Clu_count.data)] ,'MenuBar', 'none','ToolBar', 'none','WindowStyle','modal');   
        
      
          Temp_class_subclass                         = Passage_par_ref(0); % Dans cette variable on va mettre les variables temporairement, avant d'être validées et faire partie de All_data.data.Categories...
          Temp_class_subclass.data                    = struct;
          Temp_class_subclass.data.Cats_Annotation    = All_data.data.Cats_Annotation;
          Temp_class_subclass.data.SubCats_Annotation = All_data.data.SubCats_Annotation;
          Temp_class_subclass.data.Annotations        = All_data.data.Annotations{Clu_count.data,1};
 
          txt_classf_loaded = uicontrol('Style','text','units', 'normalized','position', [0.27 0.9 0.2 0.06],'String','','backgroundcolor',[1 1 1]);
          
          butt_save_class   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.75 0.9 0.2 0.06],'String','Save Classification','callback',{@Save_class,Temp_class_subclass});

          butt_cancel       = uicontrol('Style','pushbutton','units', 'normalized','position', [0.32  0.05  0.1 0.06],'String','Cancel','callback',{@Cancel,hC,Temp_class_subclass},'BackgroundColor',[1 0 0]);

          butt_val_close    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.71  0.05 0.2 0.06],'String','Validate and close','callback',{@Validate_and_close, All_data, Temp_class_subclass,hC,Clu_count,hand_plots,All_info},'BackgroundColor',[0 1 0]);
 
         % butt_val_cat      = uicontrol('Style','pushbutton','units', 'normalized','position', [0.1  0.12  0.2  0.06],'String','Validate category','callback',{@Val_cat});

  
          txt_cat           = uicontrol('Style','text','units', 'normalized','position', [0.15   0.8 0.1  0.04],'String','Category','backgroundcolor',[1 1 1]);

          txt_sub_cat       = uicontrol('Style','text','units', 'normalized','position', [0.5   0.8 0.12 0.06],'String','Sub-category','backgroundcolor',[1 1 1]);

          txt_val_cat_scat  = uicontrol('Style','text','units', 'normalized','position', [0.7   0.8 0.2 0.06],'String','Validated cats/subcats','backgroundcolor',[1 1 1]);

          liste_val_cat_s   = uicontrol('Style', 'listbox','units', 'normalized','position', [0.7  0.2 0.2 0.6],'string','','Callback',{@Erase_cat_sub_cat_list,Temp_class_subclass});

          liste_sub_cat     = uicontrol('Style', 'listbox','units', 'normalized','position', [0.45  0.2 0.2 0.6],'string',''); %,'Callback',{@Disp_list1,All_info,liste21});

          liste_cat         = uicontrol('Style', 'listbox','units', 'normalized','position', [0.1  0.2 0.2 0.6],'string','', 'Callback',{@Disp_subcat, Temp_class_subclass,liste_sub_cat}); %,'Callback',{@Disp_list1,All_info,liste21});

          butt_load_class   = uicontrol('Style','pushbutton','units', 'normalized','position',[0.05 0.9 0.2 0.06],'String','Load Classification','callback',{@Load_class,Temp_class_subclass,txt_classf_loaded,liste_cat,liste_sub_cat});

          butt_erase_catscat= uicontrol('Style','pushbutton','units', 'normalized','position',[0.92  0.5 0.07 0.06],'String','Erase','callback',{@Erase});
          
          butt_add_to_list  = uicontrol('Style','pushbutton','units', 'normalized','position', [0.45   0.12  0.2  0.06],'String','Add to list','callback',{@Add_to_list,liste_cat,liste_sub_cat,Temp_class_subclass,liste_val_cat_s});
 
          butt_add_cat      = uicontrol('Style','pushbutton','units', 'normalized','position', [0.32  0.65 0.1 0.06],'String','Add category','callback',{@Add_cat,liste_cat,Temp_class_subclass});
 
          butt_add_subcat   = uicontrol('Style','pushbutton','units', 'normalized','position', [0.32  0.35 0.12 0.06],'String','Add subcategory','callback',{@Add_subcat,liste_cat,liste_sub_cat,Temp_class_subclass});


         % but_erase_Cat     = uicontrol('Style','pushbutton','units', 'normalized','position', [0.15  0.03 0.085 0.06],'String','X cat','callback',{@Erase_Cat,liste_cat,liste_sub_cat,Temp_class_subclass},'backgroundcolor',[1 0.65 0]);
          but_erase_Scat    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.5   0.03  0.085  0.06],'String','X s-cat','callback',{@Erase_SCat,liste_cat,liste_sub_cat,Temp_class_subclass},'backgroundcolor',[1 0.65 0]);

          

          if All_data.data.Cats_Annotation{1,1}
              set(liste_cat,'String',All_data.data.Cats_Annotation)
              
              Temp_class_subclass.data.Annotations = All_data.data.Annotations{Clu_count.data,1}  ;

              % Create the string list

            %%%%%%%%% Update also the categories which are already
            %%%%%%%%% validated
            
               Mat_temp      = Temp_class_subclass.data.Annotations;
               if size(Mat_temp,1)
                   str_val         = cell(size(Mat_temp,1),1);
                     for uy = 1:size(Mat_temp,1)
                           str1           = Mat_temp{uy,1};    %  Temp_class_subclass.data.Cats_Annotation{Mat_temp(uy,1),1};
                           str2           = Mat_temp{uy,2};    %  Temp_class_subclass.data.SubCats_Annotation{Mat_temp(uy,1),1};
                           str_val{uy,1}  = [str1,'   /   ',str2];
                     end  
                    set(liste_val_cat_s,'String', str_val); 
               end
          end
else
    msgbox('Load the data and plot it !')
end    
          
         function Disp_subcat(object_handle, event, Temp_class_subclass,liste_sub_cat)
                Num_class                     =  get(object_handle,'Value');
                tmp                           =  Temp_class_subclass.data.SubCats_Annotation;

                set(liste_sub_cat,'Value',1);
                
                lst                           =  tmp{Num_class,1};
                set(liste_sub_cat,'String', lst); 
          end     
          
          

    function Add_cat(object_handle, event,liste_cat,Temp_class_subclass)

        x = [];
        while length(x) == 0
             x                         = inputdlg('Input new category','Sample', [1 50]);
        end
         lst                           =  get(liste_cat,'String');
         lst                           =  [lst;cell(1,1)];
         lst{end,1}                    =   x{:};
         set(liste_cat,'String',lst)
         Temp_class_subclass.data.Cats_Annotation    = lst;
         Temp_class_subclass.data.SubCats_Annotation = [Temp_class_subclass.data.SubCats_Annotation; cell(1,1)];
    end


      function Add_subcat(object_handle, event,liste_cat,liste_sub_cat,Temp_class_subclass)
           if length(get(liste_cat,'String'))  
          
                   Num_cat            = get(liste_cat,'Value');
                   lst_sub_cat_temp   = Temp_class_subclass.data.SubCats_Annotation{Num_cat,1};             
                   x = [];
                    while length(x) == 0
                         x                             = inputdlg('Input new sub category','Sample', [1 50]);
                    end

                     lst_sub_cat_temp                           =  [lst_sub_cat_temp;cell(1,1)];
                     lst_sub_cat_temp{end,1}                    =   x{:};

                     set(liste_sub_cat,'String',lst_sub_cat_temp)
                     Temp_class_subclass.data.SubCats_Annotation{Num_cat,1} = lst_sub_cat_temp;
           else
               msgbox('You must create first a category')
           end  
    end
 
      
     
      
      
      
      function Erase_SCat(object_handle, event,liste_cat,liste_sub_cat,Temp_class_subclass)
      
        L_scat_displayed = get(liste_sub_cat,'String');    % start by looking at what is displayed in liste subcat.
        if iscell(L_scat_displayed)
             Num_cat                      = get(liste_cat,'Value');
             Num_scat                     = get(liste_sub_cat,'Value');
             lst_sub_cat_temp             = Temp_class_subclass.data.SubCats_Annotation{Num_cat,1};
            
              msgbox('Be careful, by changing the subcategories, you might have to annotate the database again !')
              answer = questdlg(['Do you want to erase ',lst_sub_cat_temp{Num_scat},'  ?'], '', 'Yes','No','No');
                % Handle response
                switch answer
                    case 'Yes'
                            lst_sub_cat_temp(Num_scat)                             = [];
                            set(liste_sub_cat,'Value',1);
                            Temp_class_subclass.data.SubCats_Annotation{Num_cat,1} = lst_sub_cat_temp;
                            set(liste_sub_cat,'String',lst_sub_cat_temp);
                            set(liste_sub_cat,'Value',1);
                    case 'No'     
                end 
        else                                               %dislay the categories
            Num_class                     =  get(object_handle,'Value');
            tmp                           =  Temp_class_subclass.data.SubCats_Annotation;
 
            lst                           =  tmp{Num_class,1};
            set(liste_sub_cat,'String', lst); 
            msgbox('Single click on the desired subcategory and  push again the X button ')
        end    
      end
      

    function Load_class(object_handle, event,Temp_class_subclass,txt_classf_loaded,liste_cat,liste_sub_cat)

                                                     
        file = 0;
        while file == 0
          [file,path] = uigetfile;
        end
        load([path,file])
        
        Temp_class_subclass.data.Cats_Annotation     = Cats_Annotation;
        Temp_class_subclass.data.SubCats_Annotation  = SubCats_Annotation;
        
        lst      =  Cats_Annotation;
        set(liste_cat,'String', lst); 
        set(liste_cat,'Value', 1); 
         
        lst_sc   = SubCats_Annotation;
        set(liste_sub_cat,'String',lst_sc{1,1});
        
        set(txt_classf_loaded,'String','Classification loaded !');
     end


    function Save_class(object_handle, event,Temp_class_subclass)
 
        Cats_Annotation     = Temp_class_subclass.data.Cats_Annotation;
        SubCats_Annotation  = Temp_class_subclass.data.SubCats_Annotation;
 
        file = 0;
        while file == 0
          [file,path] = uiputfile;
        end
        save([path,file],'Cats_Annotation','SubCats_Annotation')

    end

    function Validate_and_close(object_handle, event,All_data,Temp_class_subclass,hC,Clu_count,hand_plots,All_info)
                
    
                  All_data.data.Cats_Annotation                        = Temp_class_subclass.data.Cats_Annotation;
                  All_data.data.SubCats_Annotation                     = Temp_class_subclass.data.SubCats_Annotation;
                  All_data.data.Annotations{Clu_count.data,1}          = Temp_class_subclass.data.Annotations;
                                                                   
                  close(hC);
                  
             if Clu_count.data
                  if length(All_data.data.Annotations{Clu_count.data,1})
             
                                       Fus_Indexes        = [];
                                       Number_of_families = size(All_info.data,2);
                                
                                for u = 1 : Number_of_families
                                       Fus_Indexes = [Fus_Indexes; All_info.data(u).Fusi_Ind];
                                end   
                                       Num_plot          = Assign_plot_num(Fus_Indexes);          % Some stims ensambles are plotted together, so we give them a similar plot number
                                       Num_diff_plots    = max(Num_plot(:,2));
                 
                      
                               hand_plots.data.hand_figs{1,Num_diff_plots+1};         
                               h_temp =  hand_plots.data.hand_axes{1,Num_diff_plots+1};         
                     
                                     STR = '';
                                      for uu= 1:size(All_data.data.Annotations{Clu_count.data,1},1)
                                              str_class = All_data.data.Annotations{Clu_count.data,1}{uu,1};
                                              str_sub_c = All_data.data.Annotations{Clu_count.data,1}{uu,2};
                                               
                                              STR     = [STR, str_class, '  /  ',str_sub_c , '      '];
                                      end    
                                        set(h_temp,'String',STR);   
                                   
                   end
              end  
    end    


    function Add_to_list(object_handle, event, liste_cat,liste_sub_cat,Temp_class_subclass,liste_val_cat_s)
    
%      v1 = get(liste_cat,'Value');
%      v2 = get(liste_sub_cat,'Value');
%      
%      if v1&&v2
%                str1          = get(liste_cat,'String');
%                str2          = get(liste_sub_cat,'String');
%                str_val       = get(liste_val_cat_s,'String');       
%                Mat_temp      = Temp_class_subclass.data.Annotations;
%                similar       = 0;
% 
%                if size(Mat_temp,1)
%                    count   = 1;
%                     while ((similar ==0)&& (count < (size(Mat_temp,1)+1)))
%                          if (Mat_temp(count,1)== v1)&&(Mat_temp(count,2) == v2)
%                              similar = 1;
%                          end 
%                          count = count + 1;
%                     end    
%                end
%                
%                if similar == 0
%                        str_val         =  [str_val;cell(1,1)];
%                        str_val{end,1}  =  [str1{v1},'   /   ',str2{v2}];
%                        set(liste_val_cat_s,'String',str_val);       
%                        Temp_class_subclass.data.Annotations = [Temp_class_subclass.data.Annotations; [v1 , v2]];
%                else
%                        msgbox(' This category has already been validated !') 
%                end    
%      else    
%                        msgbox('You must enter a category and a subcategory')
%      end
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% V2     

                 v1            = get(liste_cat,'Value');
                 v2            = get(liste_sub_cat,'Value');
                 str_val       = get(liste_val_cat_s,'String');       
 
        if v1&&v2

                 str1          = get(liste_cat,'String');
                 str2          = get(liste_sub_cat,'String');   
                 
                 Cell_temp     = Temp_class_subclass.data.Annotations;
                 similar       = 0;
                 
                  if size(Cell_temp,1)
                   count   = 1;
                    while ((similar ==0)&& (count < (size(Cell_temp,1)+1)))
                         if   strcmp(Cell_temp{count,1},str1{v1})&& strcmp(Cell_temp{count,2},str2{v2})
                              similar = 1;
                         end 
                         count = count + 1;
                    end    
                  end
                 
                   if similar == 0
                       str_val         =  [str_val;cell(1,1)];
                       str_val{end,1}  =  [str1{v1},'   /   ',str2{v2}];
                       set(liste_val_cat_s,'String',str_val);       
                       Temp_class_subclass.data.Annotations = [Temp_class_subclass.data.Annotations; [{str1{v1},str2{v2}}]];
                   else
                       msgbox(' This category has already been validated !') 
                   end    
                   
        else        
                msgbox('You must enter a category and a subcategory') 
        end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    end
       
    function Erase_cat_sub_cat_list(object_handle, event,Temp_class_subclass)
    val = get(object_handle,'Value'); 
    str = get(object_handle,'String');
    
            if length(val) && length(str)
                 choice = questdlg(['Are you sure you want to erase  ',str{val},'  ?'], '','Yes','Cancel','Cancel');
                % Handle response
                switch choice
                     case 'Yes'
                         
                        Temp_class_subclass.data.Annotations(val,:) = [];
                        str_val                                     = get(object_handle,'String');       
                        str_val(val)                                = []; 
                        set(object_handle,'String',str_val);
                        set(object_handle,'Value',1);
                        
                     case 'Cancel'
                end
            end
    end
    
    
     
    
  
    function Erase(object_handle, event)
         msgbox('double click on the list of the selected categories/ sub-categories')
    end
    
          
    function Cancel(object_handle, event,hC,Temp_class_subclass)
        Temp_class_subclass     = Passage_par_ref(0);  % We put back to zero the temporal variable
        close(hC);
    end
          
          
          
%end
