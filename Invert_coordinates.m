function [line, column] = Invert_coordinates(Present_Position,Diagonal_Position)

      % goes from the position in relative coordinates (normalized to 1) to
      % relative positions on the matrix
      % This function performs the inverse operation than the function 
      % Dimensionate frame
      
          
          f_dy         = .29; % Same constants than Dimensionate_frame
          f_dx         = .15;

          left_Diag    = Diagonal_Position(1);
          bottom_Diag  = Diagonal_Position(2);
          
          width        = Diagonal_Position(3);
          height       = Diagonal_Position(4);
        
          left_Present = Present_Position(1);
          bott_Present = Present_Position(2);       
          
 
          dy           = height*f_dy;   
          dx           = width*f_dx;   
          
          n            = round( (1/height - 3*f_dy)/(1+ f_dy)); % n is the total number of lines
          %m            = round( (1/width -  4*f_dx)/(1+ f_dx)); % m                        columns     
       
          column       =     round((left_Present   - 4*dx)/( width +dx)) + 1; 
          line         = n - round((bott_Present - 3*dy)/( height+dy)); 
          
      
end



% s        = size(All_data);
% n        = s(1);     % 
% m        = s(2);
%  
% f_dy     = .29;
% height   =  1/ (n*(1 + f_dy ) + 3*f_dy );   
% dy       = height*f_dy;   
% 
% f_dx     = .15;
% 
% width    = 1/ (m*(1 + f_dx ) + 4*f_dx  ); 
% dx       = width*f_dx;   
% 
%   
% 
% left   =    4*dx    + (j-1)*( width +dx );
% bottom =    3*dy      + (n-i)*( height+dy );  
% 
%  

%end


