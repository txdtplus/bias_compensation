 function [r,c] = cal_RPC(X,Y,Z,DRPC,n_par)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
LONG_par = n_par(:,1);
LAT_par = n_par(:,2);
H_par = n_par(:,3);
r_par = n_par(:,4);
c_par = n_par(:,5);

Xn = (X-LONG_par(2))/LONG_par(1);
Yn = (Y-LAT_par(2))/LAT_par(1);
Zn = (Z-H_par(2))/H_par(1);

n = zeros(20,1);
n(1) = 1;     n(2) = Xn;    n(3) = Yn;       n(4) = Zn;
n(5) = Xn*Yn; n(6) = Xn*Zn; n(7) = Yn*Zn;    n(8) = Xn^2;
n(9) = Yn^2;  n(10) = Zn^2; n(11) = Xn*Yn*Zn; n(12) = Xn^3;
n(13) = Xn*Yn^2; n(14) = Xn*Zn^2; n(15) = Xn^2*Yn; n(16) = Yn^3;
n(17) = Yn*Zn^2; n(18) = Xn^2*Zn; n(19) = Yn^2*Zn;  n(20) = Zn^3;

p1 = DRPC(:,1); p2 = DRPC(:,2); p3 = DRPC(:,3); p4 = DRPC(:,4);

rn = (p1'*n)/(p2'*n);
cn = (p3'*n)/(p4'*n);

r = rn*r_par(1)+r_par(2);
c = cn*c_par(1)+c_par(2);
end

