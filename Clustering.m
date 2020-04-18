%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        dimS        =  get(0,'ScreenSize');  
        h_clu       =  figure('Color','white','Position',dimS,'Name','Clustering ');  

        
        h_List_of_files_to_cluster   = Passage_par_ref({});
        h_Add_info                   = Passage_par_ref([]);
        h_Raw_data                   = Passage_par_ref([]);
        h_Clusters                   = Passage_par_ref([]);
        h_distance                   = Passage_par_ref(0.86);

        
        h_liste                      = uicontrol('Style', 'listbox','units', 'normalized','position', [0.5 0.15 0.4 0.5]);%,'Callback',{@UpdateListBox,h_List_of_files_to_cluster});
    
        text_clustering_adress       = uicontrol('style','text','string','','units', 'normalized','position',[0.05 0.19 0.3 0.05],'BackgroundColor',[1 1 1]);

        text_adress                  = uicontrol('style','text','string','Save result in address:','units', 'normalized','position',[0.05 0.24 0.15 0.05],'BackgroundColor',[1 1 1]);

         
        but_load                     = uicontrol('style', 'pushbutton','string', 'Load files',...
                                         'units', 'normalized','position',[0.05 0.9 0.2 0.05],'callback',{@Load_files,     h_List_of_files_to_cluster, h_liste }); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
       
        text_actual_adress           = uicontrol('style','text','string','','units', 'normalized','position',[0.35 0.84 0.3 0.05],'BackgroundColor',[1 1 1]);
        
        but_save_list_files          = uicontrol('style', 'pushbutton','string', 'Save list of files',...
                                         'units', 'normalized','position',[0.35 0.9 0.2 0.05],'callback',{@Save_list_files,h_List_of_files_to_cluster,text_actual_adress}); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
           

                                     
        but_del_list_files           = uicontrol('style', 'pushbutton','string', 'Delete list of files',...
                                         'units', 'normalized','position',[0.65 0.9 0.2 0.05],'callback',{@Delete_list_of_files,h_List_of_files_to_cluster, h_liste,text_clustering_adress,text_actual_adress}); % [ left0   bottom0  width0  height0/2],'callback',  {@);           
                                             
        
        but_run_cluster              = uicontrol('style', 'pushbutton','string', 'Run clustering',...
                                         'units', 'normalized','position',[0.05 0.55 0.15 0.15],'callback',{@Run_cluster,h_List_of_files_to_cluster,h_Add_info,h_Raw_data}); 
  
        
        but_add_info                 = uicontrol('style', 'pushbutton','string', 'Add info',...
                                         'units', 'normalized','position',[0.05 0.76 0.15 0.05],'callback',{@Add_info,  h_List_of_files_to_cluster, h_Add_info}); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
                                
        text_load_save_info          = uicontrol('style','text','string','','units', 'normalized','position',[0.35 0.69 0.3 0.05],'BackgroundColor',[1 1 1]);      
                                     
                                     
        but_load_info                = uicontrol('style', 'pushbutton','string', 'Load info',...
                                         'units', 'normalized','position',[0.27 0.76 0.15 0.05],'callback',{@Load_info,  h_List_of_files_to_cluster, h_Add_info,text_load_save_info}); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
                                    
        but_save_info                = uicontrol('style', 'pushbutton','string', 'Save info',...
                                         'units', 'normalized','position',[0.49 0.76 0.15 0.05],'callback',{@Save_info,  h_Add_info, text_load_save_info}); 
                                    
        but_del_info                 = uicontrol('style', 'pushbutton','string', 'Delete info',...
                                         'units', 'normalized','position',[0.71 0.76 0.15 0.05],'callback',{@Delete_info,   h_Add_info, text_load_save_info}); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
                                       
        but_establish_d_verify_hom   = uicontrol('style', 'pushbutton','string', 'Set distance, compute clusters, save ',...
                                         'units', 'normalized','position',[0.05 0.3 0.25 0.05],'callback',{@Establish_d_verify_hom, h_Raw_data, h_Clusters, h_distance,text_clustering_adress}); % [ left0   bottom0  width0  height0/2],'callback',  {@);%
                                       

function Load_files(object_handle, event, h_List_of_files_to_cluster, h_liste)
       
               if ispc
                  slash =  '\';
               elseif isunix || ismac   
                  slash =  '/';
               end
 
             choice = questdlg(' Choose files to cluster','Clustering', 'Choose files to cluster one by one','Select the files from a predefined list','Select folder containing all the relevant files','Select folder containing all the relevant files');
              switch choice
                  case 'Choose files to cluster one by one'
                   List =  {};            
                   count=   1;   
                   ok   =   1;
                                     while ok == 1
                                        choice_f = questdlg('Choose a file ?', 'List of files', 'Yes','Stop','Stop');
                                                 switch choice_f
                                                    case 'Yes'
                                                        
                                                           folder_name = uigetdir;
                                                           index       = find(folder_name == slash);
                                                           file        = folder_name(index(end) +1:end);
                                                           
                                                           List{count} = folder_name;
                                                           count       = count + 1;    
                                                           disp(folder_name)
                                                     case 'Stop'
                                                        ok = 0;
                                                        disp('List complete')
                                                end
                                     end
                  case 'Select the files from a predefined list' 
                                         filename = '';
                                            while strcmp(filename,'')
                                                 [filename, pathname] = uigetfile({'*.mat'},'File Selector');
                                            end
                                         load([pathname,filename])   % load the file containing the list of files in a format: List = cells{1,numfiles}
                  case 'Select folder containing all the relevant files'                       
                                         folder_name = uigetdir;
                                         files_info  = dir(folder_name);
                                         if ~isreal(files_info) % if files info is a variable
                                                 for num = 3: length(files_info)
                                                       List{num-2} = [folder_name,slash,files_info(num).name]; 
                                                 end   
                                         end
                                           
              end
                                         h_List_of_files_to_cluster.data = List;
                                         h_liste.String                  = List;                                       
                                         
end       

function Save_list_files(object_handle, event, h_List_of_files_to_cluster,text_actual_adress)

       List           = h_List_of_files_to_cluster.data;
      
       %uisave({'List'},'');
      [file,path] = uiputfile('*.mat','Save list fo files as:');
      if length(path) && exist('List')
         save([path,file], 'List'); 
         set(text_actual_adress,'String',[path,file])
      end
end

function Delete_list_of_files(object_handle, event, h_List_of_files_to_cluster,h_liste, text_clustering_adress,text_actual_adress)
      h_List_of_files_to_cluster.data = {};
      h_liste.String                  = {};
      
      text_clustering_adress.String   = ''; 
      set(text_actual_adress,'String','');
end


function Add_info(object_handle, event,h_List_of_files_to_cluster, h_Add_info)

   if ispc
      slash =  '\';
   elseif isunix || ismac   
      slash =  '/';
   end

     if length(h_List_of_files_to_cluster.data)
  
         Table_ColInd_FileInd_Depth = [];
            for ww = 1 : length(h_List_of_files_to_cluster.data)
                     
                
                            temp_file  = h_List_of_files_to_cluster.data{ww};
                            ind_char   = find(temp_file == slash);
                            temp_file  = temp_file((ind_char(end)+1): end);
                
                            temp_mouse_order = '';
                            
                            while strcmp(temp_mouse_order,'') 
                                prompt           = {'Enter mouse number (as in the experiments, it doesn''t need to have order):','Depth (µm):'};
                                title            = temp_file;
                                dims             =  [1 60];
                                definput         = {'','0'};
                                answer           = inputdlg(prompt,title,dims,definput);
                                if ~isreal(answer) % this means that the user didn't simply cancelled the dialog box
                                    temp_mouse_order  =  answer{1};
                                end
                            end 
                            Table_ColInd_FileInd_Depth = [Table_ColInd_FileInd_Depth;[str2double(answer{1}) ,ww , str2double(answer{2})]];

            end
                            h_Add_info.data =  Table_ColInd_FileInd_Depth;
            
     else
        msgbox('First load files to cluster, then introduce additional information about them !')  
     end
end

function Load_info(object_handle, event,h_List_of_files_to_cluster, h_Add_info,text_load_save_info)

     [FileName,PathName,~] = uigetfile('*.mat');
     if length(PathName)
          load([PathName, FileName])
     
          if exist('Table_ColInd_FileInd_Depth')
                  h_Add_info.data  = Table_ColInd_FileInd_Depth;
                  set(text_load_save_info,'String',[PathName,FileName]);
          end
     end
end

function Save_info(object_handle, event, h_Add_info, text_load_save_info)

      Table_ColInd_FileInd_Depth  = h_Add_info.data;
      [file,path] = uiputfile('*.mat','Save additional info as:');
      if length(path) 
         save([path,file], 'Table_ColInd_FileInd_Depth'); 
         set(text_load_save_info,'String',[path,file])
      end
end


function Delete_info(object_handle, event, h_Add_info, text_load_save_info)
   h_Add_info.data = [];
   set(text_load_save_info,'String','');
end


function Run_cluster(object_handle, event, h_List_of_files_to_cluster,h_Add_info, h_Raw_data)
         

    Table_ColInd_FileInd_Depth    = h_Add_info.data; 
    Liste                         = h_List_of_files_to_cluster.data;

    % Check whether the number of labels is the same as the number of
    % experiments

    same = 0;
    if (length(Liste) == size(Table_ColInd_FileInd_Depth,1))
        same = 1;
    end    
        
    Buffer        = [];
    Buffer_labels = [];
    
     if ~isempty(h_List_of_files_to_cluster.data)
         
         disp('Loading Files')
            for u = 1:  length(Liste)
                  folder_name =  Liste{1,u};  
                    Responses                =   Data2Stim(folder_name,folder_name);
                                                  
                    Resp                     =   Responses.TracesDg;
                    dt                       =   Responses.dt;             % Attention !! le dt pourrait avoir une autre valeur si on doit réajuster les valeurs ! 
  
                    Resp_chosen              =   Resp; 
                    [n_cells,n_time,n_stim]  =   size(Resp_chosen);
                    Resp_chosen_res          =   reshape(Resp_chosen,[n_cells, n_time*n_stim]);

                    I_nan                    =   isnan(mean(Resp_chosen_res,2));
                    
                    Resp_chosen_res(I_nan,:) = [];
                    
                    
                    if same ==1
                       Labels_temp           = kron(Table_ColInd_FileInd_Depth(u,:),ones(n_cells,1));
                       Labels_temp(I_nan,:)  = [];
                       Buffer_labels         = [Buffer_labels;Labels_temp];
                    end
                      
                      Buffer                 = [Buffer; Resp_chosen_res]; 
            end
                     disp('Starting clustering')

                      tic;
                      C_pdist                = pdist(Buffer ,'correlation');
                      Z                      = linkage(C_pdist,'complete');
                      N_cells                = size(Z,1)+1;
                      time                   = toc;
                      disp(['clustering completed in ',num2str(time),' seconds'])
                          
                      h_Raw_data.data         = struct;
                      h_Raw_data.data.Buffer  = Buffer;
                      h_Raw_data.data.Z       = Z;
                      h_Raw_data.data.N_cells = N_cells;
                      h_Raw_data.data.n_time  = n_time;
                      h_Raw_data.data.n_stim  = n_stim;
                      %h_Raw_data.data.C_pdist = C_pdist;
                      h_Raw_data.data.dt      = dt;

                      if same
                       h_Raw_data.data.Buffer_labels = Buffer_labels;
                      end
     end
  
end




function Establish_d_verify_hom(object_handle, event, h_Raw_data, h_Clusters, h_distance,text_clustering_adress)

   if length(h_Raw_data.data)
         
                      
                   ok       = 0; 
                   while ok ==0 
                       prompt   = {'d :'};
                       title    = 'Enter the distance at which to cut the tree (a number between 0 and 2)';
                       dims     = [1 35];
                       definput = {num2str(h_distance.data)};
                       answer   = inputdlg(prompt,title,dims,definput);         
                        
                       if (str2num(answer{1}) > 0) && (str2num(answer{1})<2) 
                            ok              = 1;
                            h_distance.data = str2num(answer{1});
                       end    
                   end      
                        
                      Buffer   =  h_Raw_data.data.Buffer;
                      Z        =  h_Raw_data.data.Z      ;
                      N_cells  =  h_Raw_data.data.N_cells;
                      n_time   =  h_Raw_data.data.n_time;
                      n_stim   =  h_Raw_data.data.n_stim;
                      %C_pdist  =  h_Raw_data.data.C_pdist;
                      dt       =  h_Raw_data.data.dt;
                      distance =  h_distance.data;
                      
                      if size(Z,2) == 3    
                             Z  = [Z, (1+N_cells: (size(Z,1) + N_cells))' ];
                      end 
                      
                      N_max_cells_per_clust   = 10;
                      Liste_cells_cluster     = Donne_liste_clusters_dmax(Z, h_distance.data, N_cells,N_max_cells_per_clust);
                                                                
                      Buff_Clust              = zeros(size(Liste_cells_cluster,1), size(Buffer,2));
                      for n_c = 1: size(Buff_Clust,1)
                           Buff_Clust(n_c,:)  = mean(Buffer(Liste_cells_cluster{n_c,1},:));
                      end
                      h_Clusters.data         = reshape(Buff_Clust,[size(Liste_cells_cluster,1), n_time ,n_stim]);
                          
                      Buff_Clust_r            = h_Clusters.data;
                         
                      Responses               = struct;
                      Responses.dt            = dt;
                      Responses.TracesDg      = Buff_Clust_r;
                      
                      
                      choice = questdlg('Verify cluster homogeneity ?', ...
                            '', 'Yes','No','No');
                        switch choice
                            case 'Yes'
                                 dessert = 1;  % Script: homogeneity: a figure in which one can observe a whole cluster at a time, zoom and do subsampling 
                            case 'No'
                        end

                          
                                choice = questdlg('Do you want to save the clustering results?','', 'No','Yes','Yes');
                                switch choice
                                    case 'Yes'
                                            x         = {};
                                            while (length(x) == 0)
                                                   [filename, pathname] = uiputfile('*.mat',...
                                                               'Save the clustering results as :');      
                                                   x         = pathname;
                                            end
                                           text_clustering_adress.String =  [pathname,filename];  
    
                                 
                                           if   isfield(h_Raw_data.data,'Buffer_labels')
                                                  Buffer_labels =  h_Raw_data.data.Buffer_labels;
                                                  save([pathname,filename],'Z','N_cells','Buffer_labels','Buffer','n_time','n_stim','distance','Responses') 
                                           else
                                                  save([pathname,filename],'Z','N_cells','Buffer','n_time','n_stim','distance','Responses') 
                                           end
                                    case 'No'
                                end
   
                         
                        
   else
       msgbox('first load the data and cluster it !')
   end

end








