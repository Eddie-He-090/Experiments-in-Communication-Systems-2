function seq = tx_gen_m_seq_ssrg(m_init)
%SSRG（简单型）结构
connections =m_init;
m=length(connections);%移位寄存器的级数
L=2^m-1;%m序列长度
registers=[zeros(1,m-1) 1];%寄存器初始化
%disp(registers);
seq(1)=registers(m);%m序列的第一位取移位寄存器移位输出的值
for i=2:L
    new_reg_cont(2:m)=registers(1:m-1);
    s=0;
    for j=1:m
        s=rem(connections(j)*registers(j)+s,2);
    end
    new_reg_cont(1)=s;
    registers=new_reg_cont;
    %disp(registers);
    seq(i)=registers(m);%经过一次循环寄存器输出一位得到m序列的其他位
end