%construction of the frame: mapping, IFFT, cyclic prefix, preamble and
%upconversion

function [txsignal,c]=txofdm(bits,c)
N=c.ofdm.ncarrier; C=c.ofdm.cplen;
assert(mod(numel(bits),2*N)==0,'Use a whole number of OFDM symbols');
[p,t]=known_sequences(c);
A=[t reshape(qmap(bits),N,[])];
x=sqrt(N)*ifft(A,[],1);
x=[x(end-C+1:end,:);x];
u=ofdm_tx_resampling(x(:),c); u=u(:);
u=u/sqrt(mean(abs(u).^2));
bb=[p;u]; n=(0:numel(bb)-1)';
txsignal=real(bb.*exp(1i*2*pi*c.f_c*n/c.f_s));
txsignal=0.8*txsignal/max(abs(txsignal));
c.frameLength=numel(txsignal); c.preambleLength=numel(p);
end
