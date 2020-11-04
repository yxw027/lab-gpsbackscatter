function [PolyValue,U_mV] = IV_CurvePolyFit( )

%% 数据处理
M = csvread('D:\Users\ASUS\Documents\Lab Research\Submit\GPS_backscatter\Project\MBD1057_IV_curve.CSV');
U_mV = M(1:360,2);
I_uA = M(1:360,3);

I_mA=smooth(I_uA/1000);

% 多项式方程推定
PolyValue = polyfit(U_mV,I_mA,5);
y1 = polyval(PolyValue,U_mV);

% y2=PolyValue(1)*((U_mV)^5)-PolyValue(2)*((U_mV)^4)+PolyValue(3)*((U_mV)^3)-PolyValue(4)*((U_mV)^2)+PolyValue(5)*((U_mV)^2)+PolyValue(6)
% DiFF=1./diff(y1);
% % NegativeRes=DiFF(72:227);
% % 
figure;
hold on
plot(U_mV,I_mA);
plot(U_mV,y1);
legend('Measured','Curve fit')
end