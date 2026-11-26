%converts QPSK symbols into bits

function b=qdemap(a)
a=a(:); b=reshape([real(a).'<0; imag(a).'<0],[],1); b=double(b);
end
