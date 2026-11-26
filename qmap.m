%converts bits in QPSK symbols

function a=qmap(b)
b=reshape(b,2,[]); a=((1-2*b(1,:))+1i*(1-2*b(2,:))).'/sqrt(2);
end
