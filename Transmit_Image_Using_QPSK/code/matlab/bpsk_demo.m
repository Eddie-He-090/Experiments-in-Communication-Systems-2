clearvars -except times;close all;warning off;
set(0,'defaultfigurecolor','w');
addpath ..\..\library
addpath ..\..\library\matlab

ip = '192.168.2.1';
addpath BPSK\transmitter
addpath BPSK\receiver
msg1=imread('cameraman.tif');
msg=imresize(msg1,[64,64]);
txdata = bpsk_tx_func(msg);
txdata = round(txdata .* 2^14);
txdata=repmat(txdata, 8,1);

%% Transmit and Receive using MATLAB libiio

% System Object Configuration
s = iio_sys_obj_matlab; % MATLAB libiio Constructor
s.ip_address = ip;
s.dev_name = 'ad9361';
s.in_ch_no = 2;
s.out_ch_no = 2;
s.in_ch_size = length(txdata);
s.out_ch_size = length(txdata).*2;

s = s.setupImpl();

in = cell(1, s.in_ch_no + length(s.iio_dev_cfg.cfg_ch));
output = cell(1, s.out_ch_no + length(s.iio_dev_cfg.mon_ch));

% Set the attributes of AD9361
in{s.getInChannel('RX_LO_FREQ')} = 2e9;
in{s.getInChannel('RX_SAMPLING_FREQ')} = 40e6;

in{s.getInChannel('RX_RF_BANDWIDTH')} = 20e6;
in{s.getInChannel('RX1_GAIN_MODE')} = 'manual';%% slow_attack manual
in{s.getInChannel('RX1_GAIN')} = 10;
% input{s.getInChannel('RX2_GAIN_MODE')} = 'slow_attack';
% input{s.getInChannel('RX2_GAIN')} = 0;
in{s.getInChannel('TX_LO_FREQ')} = 2.86e9;
in{s.getInChannel('TX_SAMPLING_FREQ')} = 40e6;
in{s.getInChannel('TX_RF_BANDWIDTH')} = 20e6;

while(1)
    if strcmpi(get(gcf,'CurrentCharacter'),'a')
      pause;
    end

    number=0;
    if strcmpi(get(gcf,'CurrentCharacter'),'B')
      number = input('please input the number of the picture : ','s');
      close all;
    end

    %       if strcmp(get(gcf,'CurrentKey'),'C')
    %           exit;
    %       end
    if number=='1'
        fprintf('hahhaha');
        msg1=imread('cameraman.tif');
        msg=imresize(msg1,[64,64]);
    end
    if number=='2'
        fprintf('hahhaha');
       msg2=imread('moon.tif');
       msg=imresize(msg2,[64,64]);    
    end
    if number=='3'
        msg3=imread('lena.tif');
        msg=imresize(msg3,[64,64]);
    end

    txdata = bpsk_tx_func(msg);
    txdata = round(txdata .* 2^14);
    txdata=repmat(txdata, 8,1);
    fprintf('Transmitting Data Block %i ...\n',i);
    i=i+1;
    in{1} = real(txdata);
    in{2} = imag(txdata);
    output = stepImpl(s, in);
    output = stepImpl(s, in);
    output = stepImpl(s, in);
    output = stepImpl(s, in);
    output = stepImpl(s, in);
    fprintf('Data Block %i Received...\n',j);
    I = output{1};
    Q = output{2};
    Rx = I+1i*Q;
    bpsk_rx_func(Rx(end/2:end));
    j=j+1;
    pause(0.1);
end
fprintf('Transmission and reception finished\n');

% Read the RSSI attributes of both channels
rssi1 = output{s.getOutChannel('RX1_RSSI')};
% rssi2 = output{s.getOutChannel('RX2_RSSI')};

s.releaseImpl();

