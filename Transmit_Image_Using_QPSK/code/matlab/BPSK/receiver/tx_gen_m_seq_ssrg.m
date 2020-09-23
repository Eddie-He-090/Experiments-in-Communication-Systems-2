function seq = tx_gen_m_seq_ssrg(m_init)
%SSRG�����ͣ��ṹ
connections =m_init;
m=length(connections);%��λ�Ĵ����ļ���
L=2^m-1;%m���г���
registers=[zeros(1,m-1) 1];%�Ĵ�����ʼ��
%disp(registers);
seq(1)=registers(m);%m���еĵ�һλȡ��λ�Ĵ�����λ�����ֵ
for i=2:L
    new_reg_cont(2:m)=registers(1:m-1);
    s=0;
    for j=1:m
        s=rem(connections(j)*registers(j)+s,2);
    end
    new_reg_cont(1)=s;
    registers=new_reg_cont;
    %disp(registers);
    seq(i)=registers(m);%����һ��ѭ���Ĵ������һλ�õ�m���е�����λ
end