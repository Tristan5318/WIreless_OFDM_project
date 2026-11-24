clear; close all; rng(11); c=config_ofdm(); c.emulator_idx=2; c.track=false;
[ber0,a,b,r]=run_link(c); c.track=true; [ber1,d]=run_link(c,b,r);
E=[a.rx.berSymbol;d.rx.berSymbol];
for i=1:2
    first=find(E(i,:)>=0.01,1); if isempty(first), first=size(E,2)+1; end
    fprintf('Mode %d: consecutive symbols below 1%% BER: %d; total below 1%%: %d; error-free: %d\n',i,first-1,sum(E(i,:)<0.01),sum(E(i,:)==0));
end
figure; plot(E.','o-'); hold on; yline(0.01); grid on; legend('No tracking','Tracking'); xlabel('Data OFDM symbol'); ylabel('BER');
plot_channel(d,'Channel 2'); save task2_results.mat E ber0 ber1 a d
