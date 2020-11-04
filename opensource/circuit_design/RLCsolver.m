function [R,L,C]=RLCsolver(Freq,Impendance,Init)
% beta0=[-1000,0.1e-12,0.1e-9];
beta0=Init;
X=Freq;
Y=Impendance;

modelfun = @(beta,x)((beta(1)*x+(beta(2)*(1./((1i)*x*(beta(3)))))./(beta(2)+(1./((1i)*x*(beta(3)))))));
beta = nlinfit(X,Y,modelfun,beta0);
R=beta(1);
L=beta(2);
C=beta(3);

end