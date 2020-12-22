%生成Lora信号
% T=1:1:100000;
clear all;
close all;
fs=10000;
N=100000;%采样点数
n=0:N-1;
t=n/fs;
f1=0.5.*t;
y=sin(2*pi*f1.*t); 
figure;
plot(t,y);

% Down CSS
DownCss=fliplr(y);
figure;
plot(t,DownCss);

% Lora信号拼接
Symblo1=y;
Symblo2=[y(25001:100000) y(1:25000)];
Symblo3=[y(50001:100000) y(1:50000)];
Symblo4=[y(75001:100000) y(1:75000)];
% 
% %%%%Demode
% fft1=DownCss.*Symblo1;
% fft2=DownCss.*Symblo2;
% fft3=DownCss.*Symblo3;
% fft4=DownCss.*Symblo4;
% figure;
% subplot(4,1,1)
% plot(fft1);
% subplot(4,1,2)
% plot(fft2);
% subplot(4,1,3)
% plot(fft3);
% subplot(4,1,4)
% plot(fft4);

% Demode
fft1=real(fftshift(DownCss.*Symblo1));
fft2=real(fftshift(DownCss.*Symblo2));
fft3=real(fftshift(DownCss.*Symblo3));
fft4=real(fftshift(DownCss.*Symblo4));
figure;
subplot(4,1,1)
plot(fft1);
subplot(4,1,2)
plot(fft2);
subplot(4,1,3)
plot(fft3);
subplot(4,1,4)
plot(fft4);