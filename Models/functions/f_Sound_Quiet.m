function  y =  f_Sound_Quiet(s, Mu_L, Mu_Q, Sigma)

% s   :   s(t) stimulus, same dimension as t.
% Mu_L ,Sigma: parameters of the sigmoïd


y = 1./ (  (  exp( -(s - Mu_Q)/Sigma ) + 1    ) .* ( exp( (s - Mu_L)/Sigma ) + 1   ) );


end