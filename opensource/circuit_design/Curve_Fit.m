close all;
close all;
%% 数据处理
M = csvread('MBD1057_IV_curve.CSV');
U_mV = M(1:360,2);
I_uA = M(1:360,3);

I_mA=I_uA/1000;

% 多项式方程推定
p = polyfit(U_mV,I_mA,5)
y1 = polyval(p,U_mV);
DiFF=1./diff(y1);
NegativeRes=DiFF(72:227);

figure;
hold on
plot(U_mV,I_mA);
plot(U_mV,y1);
legend('Measured','Curve fit')


% Res= U_mV./I_mA;
% Pr = polyfit(U_mV,Res,5)
% Yr = polyval(Pr,U_mV);
% figure;
% hold on
% plot(U_mV,Res*50);
% %  plot(U_mV,Yr);
% plot(U_mV,I_mA.*500000);
% plot(DiFF);
% axis tight
% legend('Res','y1','Diff')
% ResDiff=1./diff(Res);
% 
% figure;
% hold on
% plot(U_mV,y1);
% plot(ResDiff);