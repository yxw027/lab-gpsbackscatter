% close all;
clear all;

M = csvread('E:\GPS_backscatter\隧道二极管\200615-DHX\7.CSV');

U_V = M(:,1);
I_A = M(:,2);
figure;
hold on
plot(U_V,I_A);
hold off
% 
M_concerned=M(484:826,:);
Ucon_V = M_concerned(:,1);
Icon_A = -M_concerned(:,2);
% Ismooth =smooth(Icon_A,27,'moving');
Imedian = smoothdata(Icon_A,'movmean');
figure;
plot(Ucon_V,Icon_A,Ucon_V,Imedian)
axis tight
legend('Noisy Data','Moving Median')

TF = isoutlier(Icon_A,'movmedian',5);
ind = find(TF)
Aoutlier = Icon_A(ind)
Icon_A(ind)=Icon_A(ind-2)
I_fill = filloutliers(Icon_A,'next');
I_fill = smoothdata(Icon_A,'movmean');
figure;
plot(Ucon_V,Icon_A,Ucon_V,I_fill)

axis tight
legend('Noisy Data with Outlier','Noisy Data with Filled Outlier')


% hold on
% plot(Ucon_V,Icon_A);
% plot(Ucon_V,Ismooth);

% p = polyfit(U_mV,I_mA,5)
% y1 = polyval(p,U_mV);
% DiFF=1./diff(y1);
% figure;
% hold on
% plot(U_mV,I_mA);
% plot(U_mV,y1);
% legend('Measured','Curve fit')
% 
% 
% Res= U_mV./I_mA;
% Pr = polyfit(U_mV,Res,5)
% Yr = polyval(Pr,U_mV);
% figure;
% hold on
% plot(U_mV,Res);
%  plot(U_mV,Yr);
% plot(DiFF);
% 
% ResDiff=1./diff(Res);
% 
% figure;
% hold on
%  plot(ReqDiff);
% plot(ResDiff);