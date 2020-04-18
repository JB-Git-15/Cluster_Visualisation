function [Stim_transformed, channels] = Two_layers_stim_transforming_spect(stimulus, kernel_size, stim_params, amp_split_params, convol_params, theta, varargin)

if ~isempty(varargin)
    use_kernel = varargin{1};
else
    use_kernel = 1;
end

Fs = stim_params{1};
dt = stim_params{2};
Nt_trial = stim_params{3};
time_trial = stim_params{4};
Mu_L = amp_split_params(1);
Mu_Q = amp_split_params(2);
SigmaL = amp_split_params(3);
SigmaQ = amp_split_params(4);
sign_OFF = convol_params(1);
sign_ON = convol_params(2);
tau = convol_params(3);

if use_kernel == 1
    Nt_trial = Nt_trial - kernel_size;
end

mag_band = band_power(stimulus, Fs, dt, length(stimulus));

nBand = size(mag_band,2);

A_L_off = zeros(Nt_trial, kernel_size, size(mag_band,2));
A_L_on = zeros(Nt_trial, kernel_size, size(mag_band,2));
A_Q_off = zeros(Nt_trial, kernel_size, size(mag_band,2));
A_Q_on = zeros(Nt_trial, kernel_size, size(mag_band,2));
A_L_ton = zeros(Nt_trial, size(mag_band,2));
A_Q_ton = zeros(Nt_trial, size(mag_band,2));


for band=1:nBand
    y_L =  f_Sound_Lound(mag_band(:,band), Mu_L, SigmaL);
    y_Q =  f_Sound_Quiet(mag_band(:,band), Mu_L, Mu_Q, SigmaQ);
    
    if ~use_kernel
        y_L = [zeros(kernel_size,1);y_L];
        y_Q = [zeros(kernel_size,1);y_Q];
    end

    for u=1:kernel_size
        A_L_off(:,u,band) = G( Diff_convolue(y_L( kernel_size - u +1: end - u), sign_OFF, time_trial, tau), theta);
        A_L_on(:,u,band) = G( Diff_convolue(y_L( kernel_size - u +1: end - u), sign_ON, time_trial, tau), theta);

        A_Q_off(:,u,band) = G( Diff_convolue(y_Q( kernel_size - u +1: end - u), sign_OFF, time_trial, tau), theta);
        A_Q_on(:,u,band) = G( Diff_convolue(y_Q( kernel_size - u +1: end - u), sign_ON, time_trial, tau), theta);
    end

    A_L_ton(:,band) = G( Tonic_convolue( y_L( kernel_size : end-1), time_trial, tau), theta);

    A_Q_ton(:,band) = G( Tonic_convolue( y_Q( kernel_size : end-1), time_trial, tau), theta);

end

Stim_transformed = [A_L_ton,...
                A_Q_ton,...
                reshape(A_L_off, [Nt_trial, kernel_size*size(mag_band,2)]),...
                reshape(A_L_on, [Nt_trial, kernel_size*size(mag_band,2)]),...
                reshape(A_Q_on, [Nt_trial, kernel_size*size(mag_band,2)]),...
                reshape(A_Q_on, [Nt_trial, kernel_size*size(mag_band,2)])];

channels = struct();
channels.name = [{'A_L_ton'}; {'A_Q_ton'}; {'A_L_off'}; {'A_L_on'}; {'A_Q_off'}; {'A_Q_on'}];
channels.indexes = [{1:nBand}; {nBand+1:nBand*2}; {nBand*2+1:nBand*(kernel_size+2)};...
        {nBand*(kernel_size+2)+1:nBand*(kernel_size*2+2)}; {nBand*(kernel_size*2+2)+1:nBand*(kernel_size*3+2)};...
        {nBand*(kernel_size*3+2)+1:nBand*(kernel_size*4+2)}];

end