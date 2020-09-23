function out_signal = insert_pilot(mod_symbols)
Nr=32;
Ns=length(mod_symbols)/Nr;
temp=reshape(mod_symbols,Ns,Nr);
pilot=[1 -1 1 -1 -1 1 -1 1];
pilot=repmat(pilot,Ns,1);
last=[pilot temp];
last=last.';
bo=last(:).';
out_signal=bo;
end
