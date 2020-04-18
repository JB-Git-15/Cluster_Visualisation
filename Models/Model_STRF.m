function [Model, Parameters] = Model_STRF(Data_to_fit, Data_to_test, T_stim , dt,  Concatenated_stims_to_fit, Concatenated_stims_to_test, Concatenated_freq_fit, Concatenated_freq_test)

tic;
disp('starting model fitting')

kernel_size = 15;

%%%% Extract nb of clusters, time steps per trial and stimuli for fitting
[n_clust, Nt_trial, n_stim_fit] = size(Data_to_fit);
n_stim_test = size(Data_to_test, 3);

%%%% Wrap the stimuli into 2s trials
time_trial = ((1:Nt_trial)*dt)';

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


%%%% Transform the input into power over frequency bands
mag_band_fit = band_power(concat_stim_fit, Fs, dt, size(wraped_stim_fit,1));


mag_band_test = band_power(concat_stim_test, Fs, dt, size(wraped_stim_test,1));
mag_band_test = [zeros(kernel_size, size(mag_band_test,2)); mag_band_test];


stim_fit = zeros(Nt_trial*n_stim_fit - kernel_size, size(mag_band_fit,2)*kernel_size);
stim_test = zeros(Nt_trial*n_stim_test, size(mag_band_test,2)*kernel_size);

for u=1:kernel_size
    stim_fit(:,(u-1)*size(mag_band_fit,2)+1:u*size(mag_band_fit,2)) = mag_band_fit(kernel_size - u+1: end - u, :);
    
    stim_test(:,(u-1)*size(mag_band_test,2)+1:u*size(mag_band_test,2)) = mag_band_test(kernel_size - u+1: end - u, :);
end

Model = zeros(size(Data_to_test));

for clust=1:n_clust
    responses = Data_to_fit(clust,:);
    kernel = pinv(stim_fit)*responses(kernel_size+1:end)';
    
    test = stim_test*kernel;
    Model(clust, :, :) = reshape(test, [Nt_trial, n_stim_test]);
end

Parameters = [];

toc;
disp('end model fitting')

end