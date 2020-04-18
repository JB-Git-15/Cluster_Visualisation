function [wraped_stimulus, stim_start] = trial_stim_wraping(stim, t_bef_stim, Fs, dt, time)

wrapping_nonstim_1 = zeros(round(t_bef_stim*Fs),1);
if length(time)*Fs*dt > length(stim)+t_bef_stim*Fs
    wrapping_nonstim_2 = zeros(ceil(length(time)*Fs*dt-(length(stim)+t_bef_stim*Fs)),1);
    wraped_stimulus = cat(1, wrapping_nonstim_1, stim, wrapping_nonstim_2);
else
    stop_index = ceil(length(time)*Fs*dt-t_bef_stim*Fs);
    wraped_stimulus = cat(1, wrapping_nonstim_1, stim(1:stop_index));
end
    
stim_start = find(time>t_bef_stim,1);

end