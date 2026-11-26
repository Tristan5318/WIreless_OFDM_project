clear; close all; rng(12); c=config_ofdm();
for id=2:5
    c.emulator_idx=id; [ber,out]=run_link(c); plot_channel(out,sprintf('Channel %d',id));
    save(sprintf('channel%d_results.mat',id),'out','ber');
end
