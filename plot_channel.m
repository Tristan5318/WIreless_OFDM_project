function plot_channel(c,label)
H=c.rx.H0; N=numel(H); B=c.ofdm.bandwidth;
f=(-N/2:N/2-1)*B/N; h=ifft(H); p=abs(h).^2;
figure('Name',label); tiledlayout(2,2);
nexttile; plot(f+c.f_c,20*log10(abs(fftshift(H))+eps)); grid on; xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
nexttile; plot((0:N-1)/B*1000,10*log10(p/max(max(p),eps)+eps)); grid on; xlabel('Circular delay (ms)'); ylabel('Relative power (dB)');
nexttile; imagesc((1:size(c.rx.Horacle,2))*(N+c.ofdm.cplen)/B,f,20*log10(abs(fftshift(c.rx.Horacle,1))+eps)); axis xy; colorbar; xlabel('Time (s)'); ylabel('Baseband frequency (Hz)'); title('Data-aided magnitude (offline)');
nexttile; plot((1:size(c.rx.Horacle,2))*(N+c.ofdm.cplen)/B,unwrap(angle(c.rx.Horacle(1:32:end,:)),[],2).'); grid on; xlabel('Time (s)'); ylabel('Unwrapped phase (rad)');
sgtitle(label);
figure('Name',[label ' constellation']); plot(real(c.rx.A(:)),imag(c.rx.A(:)),'.'); axis equal; grid on; xlabel('I'); ylabel('Q');
end
