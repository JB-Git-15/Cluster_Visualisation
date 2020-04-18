function y = Tonic_convolue(s_star, t,tau)

%    prend en entrées des colonnes...



y_full      = conv( s_star, Ksi(t,tau));

y = y_full(1:length(s_star));


end
