clear; c=config_ofdm(); [p,~]=known_sequences(c);
N=c.ofdm.ncarrier; C=c.ofdm.cplen; B=c.ofdm.bandwidth; D=c.nbits/(2*N);
T=numel(p)/c.f_s+(D+1)*(N+C)/B;
fprintf('Frame duration %.6f s; throughput %.3f bit/s; efficiency %.6f bit/s/Hz\n',T,c.nbits/T,c.nbits/T/B);
