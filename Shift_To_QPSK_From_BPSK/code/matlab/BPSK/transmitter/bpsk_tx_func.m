function txdata = bpsk_tx_func
%% train sequence
% 帧同步信号
seq_sync=tx_gen_m_seq([1 0 0 0 0 0 1]);
sync_symbols=tx_modulate(seq_sync, 'BPSK');
sync_symbols=sync_symbols+sync_symbols*1i;
%% message 128-4 byte
% msgStr=[
%     'a--------------a',...
%     '-b------------b-',...
%     '--c----------c--',...
%     '---d--------',...
%     ];

msgStr=input('Input: ','s');

%% string to bits
% mst_bits=str_to_bits(msgStr);
% 交错编码 加入32位变512位
mst_bits=str_to_bits(msgStr);
if length(mst_bits)<480
    mst_bits = [mst_bits zeros(1,480-length(mst_bits))];
%     mst_bits(1:16) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
end
if length(mst_bits)>480
    mst_bits = mst_bits(1:480);
%     mst_bits(1:16) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
end

%% crc32
% 循环冗余校验码
ret=crc32(mst_bits);
inf_bits=[mst_bits ret.'];
%% scramble
% 加扰，白噪声化，频谱均匀化，防止出现连续的0和1
scramble_int=[1,1,0,1,1,0,0];
sym_bits=scramble(scramble_int, inf_bits);
%% modulate
% mod_symbols=tx_modulate(sym_bits, 'BPSK');
mod_symbols=tx_modulate(sym_bits, 'QPSK');
%% insert pilot
% 插入载频
data_symbols=insert_pilot(mod_symbols);
trans_symbols=[sync_symbols data_symbols];
%% srrc
% 滚降滤波
fir=rcosdesign(1,128,4);
tx_frame=upfirdn(trans_symbols,fir,4);
tx_frame=[tx_frame, zeros(1,2e3)];
txdata = tx_frame.';
%% display
plot(real(tx_frame)); % 蓝色
hold on
plot(imag(tx_frame)); % 红色
end

