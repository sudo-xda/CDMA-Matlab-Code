close all;
clc;
%N=6; 
%data=input('Enter Binary Data In Form of 0 and 1 in [ ] : ');
data=[1 0 0 1 1 0 1 1];
figure('Name','Message BPSK Modulation','NumberTitle','off')
subplot(2,2,1);
plot(rectpulse(data,100)); 
axis([0 length(rectpulse(data,100)) -0.2 1.2]);
title('Message Signal');
xlabel('n');
ylabel('x(n)');
grid on;
data(data(:)==0)=-1;
length_data=length(data);
fc1=10; 
eb=2; 
tb=1; 
T=1;
msg=rectpulse(data,100);
subplot(2,2,2);
plot(msg);
title('Message Signal in NRZ form');
xlabel('n');
ylabel('x(n)');
axis([0 100*length_data -1.2 1.2]);
grid on;
N=length_data;
Tb = 0.0001;
nb=100;
br = 1/Tb;    
Fc = br*10;   
t2 = Tb/nb:Tb/nb:Tb;             
t1=0.01:0.01:length_data;
bpskmod=sqrt(2/T)*cos(2*pi*fc1*t1);
bpsk_data=msg.*bpskmod;
subplot(2,2,3)
plot(bpsk_data)
title(' BPSK signal');
xlabel('Time Period(t)');
ylabel('x(t)');
axis([0 100*length_data -2 2]);
grid on;
subplot(2,2,4);
plot(real(fft(bpsk_data)));
title('FFT of BPSK signal');
xlabel('Frequency');
ylabel('PSD');
grid on;
sr=[1 -1 1 -1];  
pn1=[];
for i=1:length_data
    for j=1:10 
        pn1=[pn1 sr(4)];  
        if sr (4)==sr(3) 
        temp=-1;
        else temp=1;
        end
              sr(4)=sr(3);
              sr(3)=sr(2);
              sr(2)=sr(1);
              sr(1)=temp;
    end
end
figure('Name','PN Generation and CDMA','NumberTitle','off');
 subplot(2,2,1);
stem(pn1);
axis([0,length(pn1),-1.2,1.2])
title('PN sequence for data')
xlabel('n');
ylabel('x(n)');
grid on;
pnupsampled1=[];
len_pn1=length(pn1);
for i=1:len_pn1
    for j=0.1:0.1:tb
    pnupsampled1=[pnupsampled1 pn1(i)];
    end
end
length_pnupsampled1=length(pnupsampled1);
subplot(2,2,2)
stem(pnupsampled1);
axis([0,length(pnupsampled1),-1.2,1.2])
title('PN sequence for data upsampled');
xlabel('n');
ylabel('x(n)');
 grid on;  
subplot(2,2,3);
sigtx1=bpsk_data.*pnupsampled1;
plot(sigtx1);
title('CDMA Signal');
xlabel('Time Period(t)');
ylabel('x(t)');
subplot(2,2,4);
plot(real(fft(sigtx1)));
title('FFT of spreaded CDMA Signal');
xlabel('Frequency');
ylabel('PSD');
grid on;
sigtonoise=20;
composite_signal=awgn(sigtx1,sigtonoise);
figure('Name','CDMA Reciever','NumberTitle','off')
subplot(2,2,1);
plot(sigtx1);
title(' Tx Signal');
xlabel('Time Period(t)');
ylabel('x(t)');
grid on;
subplot(2,2,2);
plot(composite_signal);
title(sprintf('Tx signal + noise\n SNR=%ddb',sigtonoise));
xlabel('Time Period(t)');
ylabel('x(t)');
grid on;

%Rx
rx=composite_signal.*pnupsampled1;
subplot(2,2,3);
plot(rx);
title('CDMA Demodulated signal');
xlabel('Time Period(t)');
ylabel('x(t)');
grid on;
%BPSK Demodulation
y=[];
bpskdemod=rx.*bpskmod;
for i=1:100:size(bpskdemod,2)
    y=[y trapz(t1(i:i+99),bpskdemod(i:i+99))];
end
  y(y(:)<=0)=-1;
   y(y(:)>=0)=1;
  rxdata=y;
subplot(2,2,4);
plot(rectpulse(rxdata,100)); 
axis([0 length(rectpulse(rxdata,100)) -1.2 1.2]);
title('Recieved Message Signal in NRZ');
xlabel('n');
ylabel('x(n)');
grid on;
rxdata(rxdata(:)==-1)=0;
rxdata(rxdata(:)==1)=1;
rxmsg=rxdata;
 figure('Name','Diffrent SNR','NumberTitle','off')
 subplot(3,1,1)
plot(rectpulse(rxmsg,100)); 
axis([0 length(rectpulse(rxmsg,100)) -0.2 1.2]);
title('Recieved Message Signal');
xlabel('n');
ylabel('x(n)');
grid on;
sigtonoise1=5;
composite_signal1=awgn(sigtx1,sigtonoise1);
subplot(3,1,2);
plot(composite_signal);
title(sprintf('Tx signal + noise\n SNR=%ddb',sigtonoise1));
xlabel('Time Period(t)');
ylabel('x(t)');
grid on;
sigtonoise2=0;
composite_signal2=awgn(sigtx1,sigtonoise2);
subplot(3,1,3);
plot(composite_signal2);
title(sprintf('Tx signal + noise\n SNR=%ddb',sigtonoise2));
xlabel('Time Period(t)');
ylabel('x(t)');
grid on;
scatterplot(composite_signal); grid minor;
title('Constellation Diagram of BPSK with Noise')
grid on
scatterplot(bpsk_data); grid minor;
title('Constellation Diagram of BPSK')
grid on
