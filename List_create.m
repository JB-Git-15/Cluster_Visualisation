%%%%%  List create : On cree des listes sur les Categories et les
%%%%%  sous-catégories définies dans les annotations

%%%%% Attention ! 

      %%%%  bouton all (préremplit toutes les annotations...cat1 ou cat2 ou
      %%%%  Liste :  rrrrrr{1,length(rrrrrr)+1} = 'r'
      %%%%  Button cancel 
      %%%%  Temp_list    = {'all'}; % initially
      %%%%  Temp_list{1,length(Temp_list)+1} = 'r'   %
      
      %%%%  Crée vecteurs de caracterisitques : un vecteur par cluster,
      %%%%  les premières caractéristiques correspondent,  au num de cluster, categories et
      %%%%  le reste aux sous-categories, ordonées...
        
       indices   = find(double(~cellfun(@isempty,All_data.data.Annotations))); % indices annotations
       n_cats    = length(All_data.data.Cats_Annotation);
       n_subcats = 0;
       for uu = 1: n_cats
           n_subcats = n_subcats + size(All_data.data.SubCats_Annotation{uu,1},1);
       end
   
          Subcat_concatenated = cell(n_subcats,1);
          Indices_subcats     = []; % Catégorie , indice début , indice de fin ( dans le vecteur qui concatène toutes les sous-cats).
          compt   = 1;
          
          for uuu = 1: n_cats
                  cell_temp             = All_data.data.SubCats_Annotation{uuu,1}; 
                  Indices_subcats       = [Indices_subcats; [uuu, compt, 0]];
              for vvv   = 1 : length(cell_temp)
                 Subcat_concatenated{compt,1} = cell_temp{vvv,1};
                 compt                        = compt +1;
              end   
                 Indices_subcats(end,3) = compt-1;
          end    
       
      %%%%%%% Data set annotation:
      
                   Mat_annots = zeros(length(indices),1 + n_cats + n_subcats);
               for num_annot  = 1: length(indices) 
                     cell_annots    = All_data.data.Annotations{indices(num_annot),:};
                     vect_annots    = zeros(1,1 + n_cats + n_subcats);
                     vect_annots(1) = indices(num_annot); 

                     for z = 1 :size(cell_annots,1)
                          %Annot_temp = cell_annots(z);
                          [index_cat,ind_subcat]  = Assign_index_cat_subcat(All_data.data.Cats_Annotation, Subcat_concatenated,All_data.data.SubCats_Annotation,cell_annots(z,:),Indices_subcats);
                          vect_annots(index_cat)  = 1;
                          vect_annots(ind_subcat) = 1;
                     end 
                         Mat_annots(num_annot,:) = vect_annots;  
               end    
               
        %%%%%%%%%%%%%%%%%%%%%%%%%% Figure 
               
               hC               = figure('Color','white','units', 'normalized','Position',[.1 0 .8 .7],'Name','Create visualisation list' ,'MenuBar', 'none','ToolBar', 'none','WindowStyle','modal');   
               str              = Passage_par_ref('');
               compressed_str   = Passage_par_ref('');
               
               str_and          = 'and';
               str_or           = 'or';
               str_not          = 'not';
               str_comma        = ',';
               str_LP           = '(';
               str_RP           = ')';
               
               txt_str          = uicontrol('Style','text','units', 'normalized','position', [0.2 0.25 0.7 0.08],'String','');%,{@Write_in_str,str,compressed_str});
               
               offset           = 0.1;
               butt_RP          = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.43+offset)   0.4 0.02 0.06],'String',')','callback',{@Write,str,compressed_str,str_RP,txt_str});
               butt_LP          = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.4 +offset)  0.4 0.02 0.06],'String','(','callback',{@Write,str,compressed_str,str_LP,txt_str});
               butt_comma       = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.46+offset)   0.4 0.015 0.06],'String',',','callback',{@Write,str,compressed_str,str_comma,txt_str});
               butt_and         = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.48+offset)   0.4 0.07 0.06],'String','and(.,.)','callback',{@Write,str,compressed_str,str_and,txt_str});
               butt_or          = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.57+offset)  0.4 0.07 0.06],'String','or(.,.)','callback',{@Write,str,compressed_str,str_or,txt_str});
               butt_not         = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.65+offset)  0.4 0.05 0.06],'String','not()','callback',{@Write,str,compressed_str,str_not,txt_str});
               butt_erase       = uicontrol('Style','pushbutton','units', 'normalized','position', [(0.72+offset)  0.4 0.07 0.06],'String','erase','callback',{@Erase,str,compressed_str,txt_str});
                
               txt_cat          = uicontrol('Style','text','units', 'normalized','position', [0.25 0.91 0.2 0.05],'String','Category','BackgroundColor','white');%,{@Write_in_str,str,compressed_str});
               txt_Scat         = uicontrol('Style','text','units', 'normalized','position', [0.65 0.91 0.2 0.05],'String','Sub-category','BackgroundColor','white');%,{@Write_in_str,str,compressed_str});

              liste_sub_cat     = uicontrol('Style', 'listbox','units', 'normalized','position', [0.6  0.6 0.3  0.3],'string',All_data.data.SubCats_Annotation{1,1},'Value',1); %,'Callback',{@Disp_list1,All_info,liste21});
              liste_cat         = uicontrol('Style', 'listbox','units', 'normalized','position', [0.2   0.6 0.3 0.3],'string',All_data.data.Cats_Annotation,'Callback',{@Disp_subcats, All_data,liste_sub_cat}); %,'Callback',{@Disp_list1,All_info,liste21});

              push_cat_only     = uicontrol('Style','pushbutton','units', 'normalized','position',[(0.1+offset)    0.4 0.1 0.06] ,'String' ,'Category only','Callback', {@Write2,str,compressed_str,txt_str,liste_cat});%,'callback' 
              push_cat_and_subC = uicontrol('Style','pushbutton','units', 'normalized','position',[(0.22+offset)   0.4 0.15 0.06],'String','Cat and subcat','Callback', {@Write3,str,compressed_str,txt_str,All_data,liste_cat,liste_sub_cat});%,'callback' 

               name_list        = uicontrol('Style','text','units', 'normalized','position', [0.3  0.1 0.2 0.08],'String','');
               butt_validate    = uicontrol('Style','pushbutton','units', 'normalized','position', [0.55  0.1 0.2 0.08],'String','Validate','callback',{@Validate,str,compressed_str, txt_str,name_list,Mat_annots,All_data,Subcat_concatenated});

               butt_cancel      = uicontrol('Style','pushbutton','units', 'normalized','position', [0.78  0.1 0.2 0.08],'String','Cancel / Close','callback',{@Close,hC, All_data, list_Annots});


               
               function [index_cat,ind_subcat] = Assign_index_cat_subcat(Cell_Cats_Annotation,Cell_SubCats_Annotation,Cells_sub_annotation_ordered,Cell_one_annotation,Indices_subcats)
                           %   One cluster may have multiple annotations:
                           %   each annotation is a 1 * 2 cell array of
                           %   strings
                           %   We suppose all the annotated data come in
                           %   pairs: categories / subcategories
                           
                             index_cat  = find([0, double(strcmp(Cell_Cats_Annotation,Cell_one_annotation{1,1}))']);  % one thinks there are no two categories that are called the same
                             
                                                                                                                      % There can be subcategories that are called the same. Therefore
                                                                                                                      % It is necessary to compare them properly
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                                            n_cats             = length(Cell_Cats_Annotation);
 
                                            n_subcats          =  size(Cell_SubCats_Annotation,1);
                                            Index_cat_sub_cats = zeros(n_cats,1 + n_cats + n_subcats);

                                            n_sub_cats_t       = 0;

                                                for uu = 1: n_cats
                                                     Index_cat_sub_cats(uu,1+uu)            = 1;
                                                     n_sub_cats_t                           = n_sub_cats_t + size(Cells_sub_annotation_ordered{uu},1);
                                                     ind_end                                = 1+n_cats + n_sub_cats_t;
                                                     ind_deb                                = ind_end - size(Cells_sub_annotation_ordered{uu},1) +1 ;
                                                     Index_cat_sub_cats(uu,ind_deb:ind_end) = 1;
                                                end                                                                                      
                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
                           
                                                    ind_sub_cat_possibles                   = find(Index_cat_sub_cats(index_cat-1,:));
                                                    ind_sub_cat_possibles                   = ind_sub_cat_possibles(2:end) -1-n_cats ;
                                         
                                                    %vect_temp                               = zeros(size(Cell_SubCats_Annotation));
                                                    %vect_temp(ind_sub_cat_possibles)        = 1; 
                                                    
                                                   Compare                                  = strcmp(Cell_SubCats_Annotation(ind_sub_cat_possibles),Cell_one_annotation{1,2});
                                                   ind_subcat                               = ind_sub_cat_possibles(Compare)+1+n_cats;
                end
        
               
               function  Disp_subcats(object_handle, event,All_data,liste_sub_cat)
               
                            Num_class                     =  get(object_handle,'Value');
                            tmp                           =  All_data.data.SubCats_Annotation;

                            set(liste_sub_cat,'Value',1);
                            lst                           =  tmp{Num_class,1};
                            set(liste_sub_cat,'String', lst); 
               end
               
               function Write(object_handle, event,str,compressed_str,str_x,txt_str)
                     compressed_str.data =  [compressed_str.data,'/',num2str(length(str_x))];  
                     str.data            =  [str.data,str_x];
                     set(txt_str,'String',str.data);
               end
               
               
               function Write2(object_handle,event,str,compressed_str,txt_str,liste_cat)          
                     val                 = get(liste_cat,'Value'); 
                     Lst                 = get(liste_cat,'String');                 
                     str_x               = Lst{val,1};
                     
                     compressed_str.data =  [compressed_str.data,'/',num2str(length(str_x))];  
                     str.data            =  [str.data,str_x];
                     set(txt_str,'String',str.data);
               end
                
               
               
               function Write3(object_handle,event,str,compressed_str,txt_str,All_data,liste_cat,liste_sub_cat)
                     
                     val                 = get(liste_cat,'Value');
                     str_cat             = get(liste_cat,'String');
                     Lst_subcat          = All_data.data.SubCats_Annotation{val,1};
                     val_s_cat           = get(liste_sub_cat,'Value');
                     str_x               = Lst_subcat{val_s_cat,1};
                     
                     compressed_str.data =  [compressed_str.data,'/',num2str(length(str_x)+1+length(str_cat{val}))];  
                     str.data            =  [str.data,str_cat{val},'-',str_x];
                     set(txt_str,'String',str.data);
               end
                
               
               function Erase(object_handle, event,str,compressed_str,txt_str)   
                  % Erase one digit of information
                   if length(compressed_str.data)
                          
                         index_slash             = find(compressed_str.data == '/');
                         temp                    = compressed_str.data(index_slash(end) + 1: end);
                         Ncarac_eff              = str2num(temp);
                         str.data                = str.data(1:end-Ncarac_eff); 
                         compressed_str.data     = compressed_str.data(1:index_slash(end)-1)  ;
                         set(txt_str,'String',str.data)
                   end 
               end
               
               function Validate(object_handle, event, str,compressed_str, txt_str,name_list,Mat_annots,All_data,Subcat_concatenated)
                  
                   txt_str_temp    =  str.data;
                   compressed_tmp  =  compressed_str.data; 
               
                 if length(compressed_tmp)
                    n_LP           = length(find(txt_str_temp == '('));
                    n_RP           = length(find(txt_str_temp == ')'));
                 
                   if ~(n_LP-n_RP) 
               
                       index_slash              = find(compressed_tmp == '/');
                      % num_el                   = str2num(compressed_tmp(end-str2num(compressed_tmp(end))+1:end));
                       Separate_str             = cell(length(index_slash),1);
                       index_slash_temp         = index_slash;   
                       for u = 1: length(index_slash) 
                           num_elements         = str2num(compressed_tmp(index_slash_temp(end)+1:end));
                           compressed_tmp       = compressed_tmp(1:end-1-length(num2str(num_elements)));
                           
                           Separate_str{u,1}    = txt_str_temp(end +1 - num_elements:end);
                           txt_str_temp         = txt_str_temp(1:end-num_elements);
                          
                          index_slash_temp      = index_slash_temp(1: end-1) ;        
                       end
                      % Invert the order of the Separate string...
                        Separate_str_ordered    = cell(length(index_slash),1);
                          for v = 1: length(index_slash)
                             Separate_str_ordered{v,1} = Separate_str{length(index_slash) - v + 1,1};
                          end
                      %  Count the number of classes
                          num_Req   = 0;  % Num req: number of requests/ categories, subcategories 
                          Index_Req = [];
                          for v = 1: length(index_slash)
                               tmp_str =  Separate_str_ordered{v,1} ;
                               if ~(strcmp(tmp_str,'(')||strcmp(tmp_str,')')||strcmp(tmp_str,'not')||strcmp(tmp_str,'or')||strcmp(tmp_str,'and')||strcmp(tmp_str,','))
                                   num_Req   = num_Req + 1;
                                   Index_Req = [Index_Req;v];
                               end
                          end
                       
                      %%%%% Get name of the list : 
                        prompt     = {'Name of the list :'};
                        dlg_title  = 'Name of the list';
                        num_lines  = 1;
                        defaultans = {''};
                        answer     = inputdlg(prompt,dlg_title,num_lines,defaultans);                        
                        set(name_list,'String',answer{1,1})
                      
                   %%%%%%  Convert the string in a unique vector. But first
                   %%%%%%  create as much vectors as there are
                   %%%%%%  Requests/categories, and then do the computation
                   %%%%%%  asked in string
                   
                           n_cats             = length(All_data.data.Cats_Annotation);
                           n_subcats          = 0;
                           
                           for uu = 1: n_cats
                               n_subcats = n_subcats + size(All_data.data.SubCats_Annotation{uu,1},1);
                           end  
                           
                            
                               Vects_to_do        =  zeros(num_Req,1 + n_cats + n_subcats);   %%%% These vectors are constitued of zeros and ones.
                             
                   
                               Index_cat_sub_cats = zeros(n_cats,1 + n_cats + n_subcats);
                               n_sub_cats_t       = 0;
                                
                                    for uu = 1: n_cats
                                         Index_cat_sub_cats(uu,1+uu) = 1;
                                         n_sub_cats_t       = n_sub_cats_t + size(All_data.data.SubCats_Annotation{uu,1},1);
                                         ind_end            = 1+n_cats + n_sub_cats_t;
                                         ind_deb            = ind_end - size(All_data.data.SubCats_Annotation{uu,1},1) +1 ;
                                         Index_cat_sub_cats(uu,ind_deb:ind_end) = 1;
                                    end
                                   
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Vect_cat_w_subcats  
                                   
                                % Tab_boolean    = nan(num_Req,1);
                     
                                 for ur = 1:num_Req
                                   strngg       = Separate_str_ordered{Index_Req(ur),1};
                                   index_marker = find(strngg == '-'); % is it a pure cat or not
                                   
                                   


                                   
                                     if length( index_marker)   % this is if we have a cat-subcat   
                                                  cat_str                              =  strngg(1:index_marker -1);
                                                  sub_cat_str                          =  strngg(index_marker +1:end);
                                                  n_cat                                =  find(double(strcmp(All_data.data.Cats_Annotation,cat_str)));

                                                  ind_subcats                          =  find(Index_cat_sub_cats(n_cat,:));
                                                  ind_subcats                          =  ind_subcats(2:end)-1-n_cats;

                                                  Compare                              =  double(strcmp(Subcat_concatenated(ind_subcats),sub_cat_str))';
                                                  Vects_to_do(ur,1+n_cat)              = 1;
                                                  Vects_to_do(ur,1+n_cats+ind_subcats) = Compare;
                                     else   
                                                  cat_str                              =  strngg;
                                                  n_cat                                =  find(double(strcmp(All_data.data.Cats_Annotation,cat_str)));
                                                  Vects_to_do(ur,1+n_cat)              =  1;
                                     end    
                                 end
                         
                                 Tab_boolean_data = nan(num_Req,size(Mat_annots,1));
                                 for w = 1: size(Mat_annots,1) 
                                        v_temp = Mat_annots(w,:);  
                                     for n_categ = 1:num_Req
                                            if  length(find(Vects_to_do(n_categ,:)))  
                                                  Tab_boolean_data(n_categ,w) = prod(v_temp(find(Vects_to_do(n_categ,:))));
                                            end    
                                     end
                                 end     
                                  
                                 Tab_data_ok_with_request   = nan(1,size(Mat_annots,1));
                                 for num_dat = 1: size(Mat_annots,1)
                                     
                                       Separate_str_ordered_temp  = Separate_str_ordered;    % in this copy of the , we are going to plug in the boolean values... and evaluate the expression. Save the result as a boolean
                                       for y = 1 : length(Index_Req)
                                          Separate_str_ordered_temp{Index_Req(y),1} = num2str(Tab_boolean_data(y,num_dat));
                                       end
                                     
                                      Str   = '';                                            % Create the strings that are going to be evaluated later....
                                      for uu = 1 : length(Separate_str_ordered_temp)
                                               Str  = [Str,Separate_str_ordered_temp{uu,1}];
                                      end    
                                     
                                      Tab_data_ok_with_request(1,num_dat)  = eval(Str);      % Key command ! evaluate the string , for all 
                                  end
                                 Tab_list_clusters = Mat_annots(find(Tab_data_ok_with_request),1);
                                 
                                    
                                          if length(Tab_list_clusters)
                                             msgbox(['There were ',num2str(length(Tab_list_clusters)),' clusters that match your request. We will save this list as ',get(name_list,'String')])
                                             
                                             choice = questdlg('Confirm you want to save the list?', ...
                                                    name_list.String,'Yes','No','Yes');
                                                % Handle response
                                                switch choice
                                                    case 'Yes'
                                                          temp                =  cell(1,2);
                                                          temp{1,1}           =  name_list.String;
                                                          temp{1,2}           =  Tab_list_clusters';
                                                          All_data.data.Lists = [All_data.data.Lists; temp];
                                                    case 'No'
                                                        
                                                end
                                             
                                             
                                             
                                             
                                          else    
                                             msgbox('The request shows no result ! ')
                                          end
                                          
                       
                   else
                       msgbox('The parenthesis do not match ! ')
                   end
                 else
                       msgbox('first enter the desired request !')  
                end      
               end 

                
               function Close(object_handle, event, hC, All_data, list_Annots)
               
                        temp     = (All_data.data.Lists(1:end,1))';
                
                        set(list_Annots,'String',temp);
                        set(list_Annots,'Value',1);
                   
                    
                        close(hC)
               end



               
