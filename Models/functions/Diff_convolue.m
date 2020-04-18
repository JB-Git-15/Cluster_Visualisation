function y = Diff_convolue( star, sign, t, tau)  


%  diff�rentie le signal qui sort des filtres haut et bas
%  multiplie par +1 ou -1 : 
%  + 1 si on 
%   -1 si off
%    prend en entr�es des colonnes...


s_star = [ star; star(end)];

temp   = sign*diff(s_star);

y_full      = conv( temp, Ksi(t,tau));

y = y_full(1:length(temp));


end
