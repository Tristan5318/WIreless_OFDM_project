%manageement of the transmission, generate bits, call TX and RX, BER
%calculation

function [ber,c,b,r]=run_link(c,b,r)
if nargin<2 || isempty(b), b=randi([0 1],c.nbits,1); end
c.nbits=numel(b); [x,c]=txofdm(b,c);
if nargin<3 || isempty(r)
    x=[zeros(c.f_s,1);x;zeros(c.f_s,1)];
    switch c.audiosystem
        case 'emulator'
            r=channel_emulator(x,c);
        case 'audio'
            if isempty(c.inputID), rec=audiorecorder(c.f_s,c.bitsps,1);
            else, rec=audiorecorder(c.f_s,c.bitsps,1,c.inputID); end
            if isempty(c.outputID), player=audioplayer([x x],c.f_s,c.bitsps);
            else, player=audioplayer([x x],c.f_s,c.bitsps,c.outputID); end
            record(rec); pause(1); playblocking(player); pause(1); stop(rec);
            r=getaudiodata(rec,'double');
        otherwise, error('Unknown channel mode');
    end
end
[bh,c]=rxofdm(r,c); E=reshape(bh~=b,2*c.ofdm.ncarrier,[]);
ber=mean(E(:)); c.rx.berSymbol=mean(E,1); c.rx.errors=sum(E(:));
% Data-aided channel estimate for offline diagnostics only.
c.rx.Horacle=c.rx.Z(:,2:end)./reshape(qmap(b),c.ofdm.ncarrier,[]);
fprintf('BER %.6g (%d/%d), sync %.3f\n',ber,c.rx.errors,numel(b),c.rx.syncPeak);
end
