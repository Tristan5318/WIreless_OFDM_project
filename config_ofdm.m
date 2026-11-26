%define all the parameters: carrier freq, bandwisth, number of carriers,
%CP, SNR, etc.

function c=config_ofdm()
c.audiosystem='emulator'; c.emulator_idx=1; c.emulator_snr=100;
c.f_s=48000; c.f_c=8000; c.bitsps=16; c.nbits=512*2*50;
c.sc.f_sym=1000; c.sc.nsyms=500; c.sc.os_factor=48;
c.sc.txpulse_length=20*c.sc.os_factor;
c.sc.txpulse=rrc(c.sc.os_factor,0.22,c.sc.txpulse_length);
c.ofdm.bandwidth=2000; c.ofdm.ncarrier=512; c.ofdm.cplen=256;
c.ofdm.spacing=c.ofdm.bandwidth/c.ofdm.ncarrier;
c.ofdm.os_factor=c.f_s/c.ofdm.bandwidth; c.modulation_order=2;
c.track=true; c.alpha=0.7; c.inputID=[]; c.outputID=[];
end
