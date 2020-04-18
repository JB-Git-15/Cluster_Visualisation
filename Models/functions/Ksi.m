function  y =  Ksi(t,tau)

y = zeros(size(t));


for uu = 1: length(t)
   if t(uu) < 0 
       y(uu) = 0;
   else
       y(uu) = exp(- t(uu)/tau)  ; 
   end
       
end


 



end