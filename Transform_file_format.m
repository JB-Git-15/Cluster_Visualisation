



  [f,p] = uigetfile();
 
   load([p,f])
  
   N_clusters = size(m,1);
  
   Responses = struct;
   
   TracesDg  = reshape(m,[N_clusters, Nframes, Nsounds]);

   Responses.TracesDg = TracesDg;
   Responses.dt       = dt;
   
   ans = 0;
   while ans == 0
    [ans, path] = uiputfile;  
   end
   
   
   save([path,'Data.mat'],'Responses')