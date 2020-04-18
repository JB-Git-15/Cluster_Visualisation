function mag_band = band_power(stimulus, Fs, dt, length_trial_input)

spect = [];
for i=1:length_trial_input:length(stimulus)
    [win_spect, freqs, ~] = spectrogram(stimulus(i:i-1+length_trial_input), round(Fs*dt), 0, 16000, Fs);
    win_spect(abs(win_spect)<0.001*max(abs(win_spect))) = 0;
    spect = horzcat(spect, sparse(win_spect));
end

mag_band      = zeros(size(spect,2),20);
mag_band(:,1) = mean(abs(spect(1:find(freqs > ceil(1.2.^5*2.^10),1),:)),1);
for k=6:23
    low_bound = find(freqs > ceil(1.2.^(k-1)*2.^10),1);
    up_bound = find(freqs > ceil(1.2.^k*2.^10),1);
    mag_band(:,k-4) = mean(abs(spect(low_bound+1:up_bound,:)),1);
end
mag_band(:,end) = mean(abs(spect(ceil(1.2.^23)+1:end,:)),1);

end