function ret = crc32(bits)
poly = [1 de2bi(hex2dec('8408'), 16)]';
bits = bits(:);

% Flip first 32 bits
bits(1:16) = 1 - bits(1:16);
% Add 32 zeros at the back
bits = [bits; zeros(16,1)];

% Initialize remainder to 0
rem = zeros(16,1);
% Main compution loop for the CRC32
for i = 1:length(bits)
    rem = [rem; bits(i)]; %#ok<AGROW>
    if rem(1) == 1
        rem = xor(rem,poly);%mod(rem + poly, 2);
    end
    rem = rem(2:17);
end

% Flip the remainder before returning it
ret = 1 - rem;

end
