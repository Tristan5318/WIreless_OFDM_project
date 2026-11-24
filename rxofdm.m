function [bits,c]=rxofdm(r,c)
N=c.ofdm.ncarrier; C=c.ofdm.cplen; L=c.ofdm.os_factor;
D=c.nbits/(2*N); [p,t]=known_sequences(c);
r=r(:); n=(0:numel(r)-1)';
bb=ofdmlowpass(2*r.*exp(-1i*2*pi*c.f_c*n/c.f_s),c,[]);
% Normalized correlation with the pulse-shaped preamble.
M=numel(p); K=numel(bb); F=2^nextpow2(K+M-1);
v=ifft(fft(bb,F).*fft(conj(flipud(p)),F)); v=v(M:K);
e=cumsum([0;abs(bb).^2]); e=e(M+1:end)-e(1:end-M);
score=abs(v).^2./(sum(abs(p).^2)*max(e,1e-12));
% Restrict candidates to those with enough remaining samples.
need=(D+1)*(N+C)*L; last=min(numel(score),K-M-need+1);
assert(last>=1,'Recording too short');
[peak,start]=max(score(1:last));
% Start FFT windows early inside the cyclic prefix for multipath tolerance.
back=min(round(C/4),floor((start+M-1)/L));
first=start+M-back*L;
u=ofdm_rx_resampling(bb(first:end),c); u=u(:);
assert(numel(u)>=(D+1)*(N+C),'Incomplete frame');
U=reshape(u(1:(D+1)*(N+C)),N+C,[]);
Z=fft(U(C+1:end,:),[],1)/sqrt(N);
H=Z(:,1)./t; H0=H; floorH=max(1e-12,1e-5*median(abs(H)));
A=zeros(N,D); raw=A; histH=zeros(N,D+1); histH(:,1)=H;
for k=1:D
    y=Z(:,k+1); raw(:,k)=y;
    eq=y.*conj(H)./max(abs(H).^2,floorH^2);
    A(:,k)=eq;
    if c.track
        decision=qmap(qdemap(eq));
        % Decision-directed phase update, preserving initial magnitude.
        err=angle(y.*conj(H.*decision));
        H=H.*exp(1i*c.alpha*err);
    end
    histH(:,k+1)=H;
end
bits=qdemap(A(:)); c.rx.H0=H0; c.rx.Z=Z; c.rx.A=A;
c.rx.Htrack=histH; c.rx.syncPeak=peak; c.rx.start=start;
c.rx.score=score; c.rx.recording=r; c.rx.early=back;
end
