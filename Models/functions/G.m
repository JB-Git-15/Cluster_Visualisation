function y = G( x, theta)

%%%% rectification 

y = zeros(size(x));


            for uuu = 1: length(x)

                 if (x(uuu) > theta)
                     y(uuu) =  x(uuu) - theta;
                 else    
                     y(uuu) = 0;
                 end   
            end







end