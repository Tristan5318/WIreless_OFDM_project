clear; close all; rng(10); c=config_ofdm(); c.track=false;
[ber,base]=run_link(c); assert(ber==0,'Debug the high-SNR link before continuing');
plot_channel(base,'Channel 1, 100 dB');
snr=-10:2:30; trials=5; errors=zeros(size(snr));
for i=1:numel(snr)
    c.emulator_snr=snr(i);
    for j=1:trials
        [~,out]=run_link(c); errors(i)=errors(i)+out.rx.errors;
    end
end
BER=errors/(trials*c.nbits); disp(table(snr.',BER.','VariableNames',{'SNR_dB','BER'}));
figure; semilogy(snr,max(BER,0.5/(trials*c.nbits)),'o-'); hold on; yline(0.01); grid on; xlabel('Emulator SNR (dB)'); ylabel('BER (zero errors shown at half-count)');
k=find(BER<0.01,1); if ~isempty(k), fprintf('Lowest tested passing SNR: %g dB\n',snr(k)); end
save task1_results.mat snr BER errors trials base
