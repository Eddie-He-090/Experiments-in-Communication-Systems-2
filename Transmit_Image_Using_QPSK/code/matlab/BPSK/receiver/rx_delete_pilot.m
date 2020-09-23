function out_signal = rx_delete_pilot(signal)
Nr=32+8;
Ns=length(signal)/Nr;
signal=reshape(signal,Nr,Ns);
signal=signal.';
out_signal=signal(:,(9:end));
out_signal=reshape(out_signal,1,16448);
c=max([abs(real(out_signal)),abs(imag(out_signal))]);
out_signal=out_signal ./c;
end

