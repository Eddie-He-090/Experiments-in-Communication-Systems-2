clearvars -except times;close all;warning off;
set(0,'defaultfigurecolor','w');
addpath ..\..\library
addpath ..\..\library\matlab

ip = '192.168.2.1';
addpath BPSK\transmitter
addpath BPSK\receiver
txdata = bpsk_tx_func;
txdata = round(txdata .* 2^14);
txdata=repmat(txdata, 8,1);

T='Log.txt';

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

input = cell(1, s.in_ch_no + length(s.iio_dev_cfg.cfg_ch));
output = cell(1, s.out_ch_no + length(s.iio_dev_cfg.mon_ch));

% Set the attributes of AD9361
input{s.getInChannel('RX_LO_FREQ')} = 2e9;
input{s.getInChannel('RX_SAMPLING_FREQ')} = 40e6;
input{s.getInChannel('RX_RF_BANDWIDTH')} = 20e6;
input{s.getInChannel('RX1_GAIN_MODE')} = 'manual'; %% slow_attack manual
input{s.getInChannel('RX1_GAIN')} = 10;
% input{s.getInChannel('RX2_GAIN_MODE')} = 'slow_attack';
% input{s.getInChannel('RX2_GAIN')} = 0;
input{s.getInChannel('TX_LO_FREQ')} = 2e9+40e3;
input{s.getInChannel('TX_SAMPLING_FREQ')} = 40e6;
input{s.getInChannel('TX_RF_BANDWIDTH')} = 20e6;


% while(1)
for Times=1:10
    fprintf('Transmitting Data Block %i ...\n',i);
    input{1} = real(txdata);
    input{2} = imag(txdata);
    output = stepImpl(s, input);
    fprintf('Data Block %i Received...\n',i);
    I = output{1};
    Q = output{2};
    Rx = I+1i*Q;
    bpsk_rx_func(Rx(end/2:end));
    
    A = getGlobal;
    if(Times==9)
        B=strcat(A(1,:),A(2,:),A(3,:),A(4,:));
        C=string(B);
        %         disp(C);
        D='String Received:';
        E=strcat(D,{32},C);
        fid=fopen(T, 'at+');
        fprintf(fid,'\n%s',E);
        fclose(fid);
        Log = importdata(T);
        disp('Log.txt Contains: ');
        disp(Log);
    end
    
    i=i+1;
    pause(0.1);
end
fprintf('Transmission and reception finished\n');

% Read the RSSI attributes of both channels
rssi1 = output{s.getOutChannel('RX1_RSSI')};
% rssi2 = output{s.getOutChannel('RX2_RSSI')};

s.releaseImpl();