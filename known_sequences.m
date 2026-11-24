function [p,t]=known_sequences(c)
% Independent deterministic sequences without changing the caller RNG.
s=RandStream('mt19937ar','Seed',731);
b=2*randi(s,[0 1],c.sc.nsyms,1)-1;
u=zeros(c.sc.nsyms*c.sc.os_factor,1); u(1:c.sc.os_factor:end)=b;
p=conv(u,c.sc.txpulse(:)); p=p/sqrt(mean(abs(p).^2));
t=qmap(randi(s,[0 1],2*c.ofdm.ncarrier,1));
end
