function [xk yk zk]=SatPosition(GpsEph,TOW,WN)
%
%
%
% PRN Toc af0 af1 af2 IODE Crs Delta_n M0 Cuc e Cus Asqrt Toe Cic OMEGA Cis i0 Crc omega OMEGA_DOT IDOT codeL2 GPS_Week L2Pdata Accuracy Health TGD IODC ttx Fit_interval
bGM84=3.986005e14;%地球引力常数
bOMEGAE84=7.2921151467e-5;% 地球自转角速度
% 1.计算卫星运行的平均角速度
A=GpsEph.Asqrt*GpsEph.Asqrt;% GpsEph(13) Asqrt
n0=sqrt(bGM84/(A*A*A));
n=n0+GpsEph.Delta_n;%GpsEph(8) delta_n
dt=TOW - GpsEph.Toe + (double(WN) -GpsEph.GPS_Week)*7*24*3600;% Toe GpsEph(14) wne GpsEph(24)
% 2.计算t时刻的卫星平近角点
mk=GpsEph.M0+n*dt;% M0 GpsEph(9)
% 3.迭代计算偏近点角
ek = mk;
    for iter = 0:1:7
        ek = mk + GpsEph.e * sin(ek);
    end
% 4.计算真近点角
  tak = atan2(sqrt(1.0 - GpsEph.e * GpsEph.e )*sin(ek), cos(ek) - GpsEph.e );
%  5.计算升交距角 phik相当于ut的导数，tak相当于ft
  phik=tak + GpsEph.omega;%  
 % 计算摄动改正项 
 corr_u=GpsEph.Cus*sin(2.0*phik)+GpsEph.Cuc*cos(2.0*phik);% cus GpsEph(11)  Cuc GpsEph(10)
 corr_r=GpsEph.Crs*sin(2.0*phik)+GpsEph.Crc*cos(2.0*phik);% Crs GpsEph(7)   Crc GpsEph(19)
 corr_i=GpsEph.Cis*sin(2.0*phik)+GpsEph.Cic*cos(2.0*phik);% Cis GpsEph(17)  Cic GpsEph(15)
% 计算摄动改正
    uk = phik + corr_u;
    rk = A * (1.0 - GpsEph.e * cos(ek)) + corr_r;
    ik = GpsEph.i0 + GpsEph.IDOT * dt + corr_i;
% 计算在轨道平面坐标系重的位置
xpk=rk.*cos(uk);
ypk=rk.*sin(uk);
earthrate=bOMEGAE84;
omegak=GpsEph.OMEGA + (GpsEph.OMEGA_DOT - earthrate)*dt - earthrate * GpsEph.Toe;%Omega GpsEph(16) OMEGA_DOT GpsEph(21) bOMEGAE84
    xk = xpk * cos(omegak) - ypk * sin(omegak)*cos(ik);
    yk = xpk * sin(omegak) + ypk * cos(omegak)*cos(ik);
    zk = ypk * sin(ik);
% position=[xk yk zk];


end