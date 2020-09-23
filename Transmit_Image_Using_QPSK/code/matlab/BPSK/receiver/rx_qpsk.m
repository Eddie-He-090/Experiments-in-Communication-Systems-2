function [soft_bits_out,evm] = rx_qpsk(rx_symbols)
%rx_symbols=rx_symbols./sqrt(2);
soft_bits = zeros(2,length(rx_symbols));

evm_real=zeros(1,length(rx_symbols));
evm_image=zeros(1,length(rx_symbols));

bit0 = real(rx_symbols);
bit1 = imag(rx_symbols);
for i=1:length(rx_symbols)
    if(abs(bit0(i))>0.5)
        if(bit0(i)>0)
            evm_real(i)=bit0(i)-1;
            evm_image(i)=bit1(i);
            bit0(i)=0;
            bit1(i)=0;
        else
            evm_real(i)=bit0(i)-(-1);
            evm_image(i)=bit1(i);
            bit0(i)=1;
            bit1(i)=1;
        end
    else
        if(bit1(i)>0)
            evm_real(i)=bit0(i);
            evm_image(i)=bit1(i)-1;
            bit0(i)=0;
            bit1(i)=1;
        else
            evm_real(i)=bit0(i);
            evm_image(i)=bit1(i)-(-1);
            bit0(i)=1;
            bit1(i)=0;
        end
    end
end

evm=(evm_real.^2+evm_image.^2).^0.5;
evm=sum(evm)/length(evm);

soft_bits(1,:) = bit0;
soft_bits(2,:) = bit1;

soft_bits_out = soft_bits(:)';