function  y =  f_Sound_Lound(s, Mu_L, Sigma)

% s   :   s(t) stimulus, same dimension as t.
% Mu_L ,Sigma: parameters of the sigmoïd


y = 1./ ( exp( - (s - Mu_L)/Sigma ) + 1   ) ;


end