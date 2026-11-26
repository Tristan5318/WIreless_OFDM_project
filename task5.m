clear; close all; rng(13); c=config_ofdm(); c.audiosystem='audio';
c.nbits=512*2*10;

% run testaudio.m and replace the corresponding IDs in input and output
c.inputID=1; c.outputID=4;


[ber,out,b,r]=run_link(c); plot_channel(out,'Real acoustic channel');
fprintf('Recording peak %.4f; clipped fraction %.6f\n',max(abs(r)),mean(abs(r)>=0.999));
figure; plot((0:numel(r)-1)/c.f_s,r); xlabel('Time (s)'); ylabel('Recorded amplitude'); grid on;
figure; plot(out.rx.berSymbol,'o-'); xlabel('OFDM symbol'); ylabel('BER'); grid on;
save task5_results.mat ber out b r; audiowrite('recorded.wav',r,c.f_s);
