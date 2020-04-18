function [Model, Parameters] =  Model_0(Data_to_fit, Data_to_test, T_stim , dt,  Concatenated_stims_to_fit, Concatenated_stims_to_test, Concatenated_freq_fit, Concatenated_freq_test)

   
%V.0 : [Model, Parameters] = Model_0(Data_to_fit, Concatenated_stim, Concatenated_freq)

tic;
disp('starting model fitting')

%%%% Just add noise on top of the data

M_val      =  0.0001;     %mean(mean(mean(Data_to_fit)))/2;
Model      =  Data_to_test ; % + M_val*randn(size(Data_to_test));
Parameters =  1;

toc;
disp('end model fitting')


end