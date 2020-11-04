% %测试不同频率的阻抗
% %在并联一个电容C和串联一个电感L的情况下计算所有阻抗
% pi=3.1416;
% w1= 2*pi* 1e9;
% w2=2*pi*1.5e9;
% w3=2*pi*1.575e9;
 Z1=7.85+(1i)*56.12;
 Z2=140.5+(1i)*55.3;
 Z3=14+(1i)*14.8;
% 
% syms R L C
% ex1 = w1*L+R*(1./((1i*w1*C)))./(R+1./((1i)*w1*C))-Z1;
% ex2 = w2*L+R*(1./((1i*w2*C)))./(R+1./((1i)*w2*C))-Z2;
% ex3 = w3*L+R*(1./((1i*w3*C)))./(R+1./((1i)*w3*C))-Z3;
% [R,L,C] = solve(ex1,ex2,ex3,'R,L,C');
% R = double(R)
% L = double(L)
% C = double(C)
% 验证
% clear all;
% close all;
% Z1=7.85+(1i)*56.12;
% Z2=140.5+(1i)*55.3;
% Z3=14+(1i)*14.8;
% Z4= 32.5+(1i)*61.9;
col=16;
Z1=Measure_Z(col,3)+(1i)*Measure_Z(col,4);
Z2=Measure_Z(col+1,3)+(1i)*Measure_Z(col+1,4);
Z3=Measure_Z(col+2,3)+(1i)*Measure_Z(col+2,4);
Z4=Measure_Z(col+3,3)+(1i)*Measure_Z(col+3,4);
Freq=[1e9,1.5e9,1.575e9,1.6e9];
Impendance=[Z1,Z2,Z3,Z4];
Init=[-1000,0.1e-12,0.1e-9];
[R,L,C]=RLCsolver(Freq,Impendance,Init)

% modelfun = @(beta,x)((beta(1)*x+(beta(2)*(1./((1i)*x*(beta(3)))))./(beta(2)+(1./((1i)*x*(beta(3)))))));
% beta0=[-1000,0.1e-12,0.1e-9];
% 
% beta = nlinfit(X,Y,modelfun,beta0)
