function [Model, Parameters] = Model_2_layers(Data_to_fit, Data_to_test, T_stim , dt,  Concatenated_stims_to_fit, Concatenated_stims_to_test, Concatenated_freq_fit, Concatenated_freq_test)
% Model Deneux, Kempf Nat Comm 2017 : the input is transformed into its spectrogram, cut into loud and quiet channels (parameters
% Mu_L, M_Q, SigmaL and SigmaQ, then ON and OFF non-linearity are applied
% (+ tonic) + heaviside step function. The kernel is finally computed with 

tic;
disp('starting model fitting')

kernel_size = 15;

%%%% Extract nb of clusters, time steps per trial and stimuli for fitting
[n_clust, Nt_trial, n_stim_fit] = size(Data_to_fit);
n_stim_test = size(Data_to_test, 3);

%%%% Parameters definition
time_trial = ((1:Nt_trial)*dt)';

tau = 0.05;
theta = 0.05;
sign_OFF = -1;
sign_ON = 1;
Mu_L = 0.5;
Mu_Q = 0.05;
SigmaL = 0.02;
SigmaQ = 0.002;

Parameters = [{tau}; {theta}; {sign_OFF}; {sign_ON}; {Mu_L}; {Mu_Q}; {SigmaL}; {SigmaQ}];

kernel_size = 15;

stim_params      = [{[]}, {dt}, {Nt_trial}, {time_trial}];
amp_split_params = [Mu_L, Mu_Q, SigmaL, SigmaQ];
convol_params    = [sign_OFF, sign_ON, tau];


%%%% Wrap stimuli into 2s trials

wraped_stim_fit = [];
for k=1:length(Concatenated_stims_to_fit)
    Fs = Concatenated_freq_fit(k);
    [wraped_stim_fit(:,k), stim_start] = trial_stim_wraping(Concatenated_stims_to_fit{k}, T_stim, Fs, dt, time_trial);
end
concat_stim_fit = wraped_stim_fit(:);

wraped_stim_test = [];
for k=1:length(Concatenated_stims_to_test)
    Fs = Concatenated_freq_test(k);
    [wraped_stim_test(:,k), stim_start] = trial_stim_wraping(Concatenated_stims_to_test{k}, T_stim, Fs, dt, time_trial);
end
concat_stim_test = wraped_stim_test(:);

Stim_transformed_fit = [];
for stim=1:n_stim_fit
    stimulus_fit                 = wraped_stim_fit(:,stim);
    
    stim_params{1}               = Concatenated_freq_fit(stim);
    [Stim_transformed, channels] = Two_layers_stim_transforming_spect(stimulus_fit, kernel_size, stim_params, amp_split_params, convol_params, theta, 1);
    
    Stim_transformed_fit         = [Stim_transformed_fit; Stim_transformed];
    
end

Stim_transformed_test = [];
for stim=1:n_stim_test
    stim_params{1}               = Concatenated_freq_test(stim);
    
    stimulus_test                = wraped_stim_test(:,stim);
    [Stim_transformed, channels] = Two_layers_stim_transforming_spect(stimulus_test, kernel_size, stim_params, amp_split_params, convol_params, theta, 0);
    Stim_transformed_test        = [Stim_transformed_test; Stim_transformed];
end

Model = zeros(size(Data_to_test));

for clust=1:n_clust
    
    responses = Data_to_fit(clust,kernel_size+1:end,:);
        
    Kernels   = pinv(Stim_transformed_fit)*responses(:);
    
%     tonics_L = Kernels(channels.indexes{1});
%     tonics_Q = Kernels(channels.indexes{2});
%     
%     Kernel_L_off = Kernels(channels.indexes{3});
%     Kernel_L_on = Kernels(channels.indexes{4});
%     
%     Kernel_Q_off = Kernels(channels.indexes{5});
%     Kernel_Q_on = Kernels(channels.indexes{6});
    
    Response_app       = Stim_transformed_test*Kernels;
    
    Model(clust, :, :) = reshape(Response_app, [Nt_trial, n_stim_test]);
end


toc;
disp('end model fitting')

end
