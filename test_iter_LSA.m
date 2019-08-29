clear; clc; close all;
load data
coff0 = coff;
n_par = Normalize_par;

%% caculate w
m = size(real_loc,1);
r = real_loc(:,1); cal_r = cal_loc(:,1);
c = real_loc(:,2); cal_c = cal_loc(:,2);
F0_1 = zeros(2*m,10);
F0_2 = zeros(10,1);

F0_2(1) = -1; F0_2(2:4) = coff0(1:3); F0_2(5) = 1;
F0_2(6) = -1; F0_2(7:9) = coff0(4:6); F0_2(10) = 1;

for i = 1:2:2*m
    F0_1(i,1) = r((i+1)/2);
    F0_1(i,2) = 1;
    F0_1(i,3) = c((i+1)/2);
    F0_1(i,4) = r((i+1)/2);
    F0_1(i,5) = cal_r((i+1)/2);
    
    F0_1(i+1,6) = c((i+1)/2);
    F0_1(i+1,7) = 1;
    F0_1(i+1,8) = c((i+1)/2);
    F0_1(i+1,9) = r((i+1)/2);
    F0_1(i+1,10) = cal_c((i+1)/2);
end
w = -F0_1*F0_2;

%% caculate A
LONG_par = n_par(:,1);
LAT_par = n_par(:,2);
H_par = n_par(:,3);
r_par = n_par(:,4);
c_par = n_par(:,5);

Xn = (X-LONG_par(2))/LONG_par(1);
Yn = (Y-LAT_par(2))/LAT_par(1);
Zn = (Z-H_par(2))/H_par(1);


du_dXn = [0 1 0 0 Yn(i) Zn(i) 0 2*Xn(i) 0 0 Yn(i)*Zn(i) 3*Xn(i)^2 Yn(i)^2 Zn(i)^2 2*Xn(i)*Yn(i) 0 0 2*Xn(i)*Zn(i) 0 0];
du_dYn = [0 0 1 0 Xn(i) 0 Zn(i) 0 2*Yn(i) 0 Xn(i)*Zn(i) 0 2*Xn(i)*Yn(i) 0 Xn(i)^2 3*Yn(i)^2 Zn(i)^2 0 2*Yn(i)*Zn(i) 0];
du_dZn = [0 0 0 1 0 Xn(i) Yn(i) 0 0 2*Zn(i) Xn(i)*Yn(i) 0 0 2*Xn(i)*Zn(i) 0 0 2*Yn(i)*Zn(i) Xn(i)^2 Yn(i)^2 3*Zn(i)^2];
