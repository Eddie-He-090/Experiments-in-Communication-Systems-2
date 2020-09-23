function txdata = bpsk_tx_func(msg)
%% train sequence
seq_sync=tx_gen_m_seq_ssrg([1 0 0 0 0 0 1]);
sync_symbols=tx_modulate(seq_sync, 'BPSK');
sync_symbols=sync_symbols+1i*sync_symbols;
%% message 128-4 byte
%msg=['a'];
%     'a--------------a',...
%     '-b------------b-',...
%     '--c----------c--',...
%     '---d--------',...
%     ];
% 
% msg=imread('cameraman.tif');
% imdata=msg;
% imdata=imresize(imdata,[64,64]);
msg=dec2bin(msg,8);
msg=msg.';
m=reshape(msg,1,32768);
for i=1:length(m)
    mst_bits(i)=str2num(m(i));
end
%% string to bits
%mst_bits=str_to_bits(msgStr);
mst_bits(32769:32864) = zeros(1,96);

%% string to bits
% mst_bits=str_to_bits(msg);
% if length(mst_bits)<480
%     mst_bits=[mst_bits zeros(1,480-length(mst_bits))];
% elseif length(mst_bits)>480
%     mst_bits=mst_bits(1:480);
% end
%  b=zeros(1,16);
%  mst_bits=[mst_bits,b];
%% crc32
ret=crc32(mst_bits);
inf_bits=[mst_bits ret.'];
%% scramble
scramble_int=[1,1,0,1,1,0,0];
sym_bits=scramble(scramble_int, inf_bits);
%% modulate
mod_symbols=tx_modulate(sym_bits, 'QPSK');
%% insert pilot
data_symbols=insert_pilot(mod_symbols);
trans_symbols=[sync_symbols data_symbols];
%% srrc   Âö³å³ÉÐÍ
fir=rcosdesign(1,128,4);
tx_frame=upfirdn(trans_symbols,fir,4);
tx_frame=[tx_frame, zeros(1,1e4)];
txdata = tx_frame.';
%% display
plot(real(tx_frame));
hold on
plot(imag(tx_frame));
end

