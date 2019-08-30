clear; clc; close all;
load data
coff0 = coff;
n_par = Normalize_par;

%% caculate w
n = 1;   % image number
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

Xn = (geoloc(:,1)-LONG_par(2))/LONG_par(1);
Yn = (geoloc(:,2)-LAT_par(2))/LAT_par(1);
Zn = (geoloc(:,3)-H_par(2))/H_par(1);

zero_m = zeros(m,1);
one_m = ones(m,1);
u = zeros(20,m);
u(1,:) = 1;     u(2,:) = Xn;    u(3,:) = Yn;       u(4,:) = Zn;
u(5,:) = Xn.*Yn; u(6,:) = Xn.*Zn; u(7,:) = Yn.*Zn;    u(8,:) = Xn.^2;
u(9,:) = Yn.^2;  u(10,:) = Zn.^2; u(11,:) = Xn.*Yn.*Zn; u(12,:) = Xn.^3;
u(13,:) = Xn.*Yn.^2; u(14,:) = Xn.*Zn.^2; u(15,:) = Xn.^2.*Yn; u(16,:) = Yn.^3;
u(17,:) = Yn.*Zn.^2; u(18,:) = Xn.^2.*Zn; u(19,:) = Yn.^2.*Zn;  u(20,:) = Zn.^3;
du_dXn = [zero_m one_m zero_m zero_m Yn Zn zero_m 2*Xn zero_m zero_m Yn.*Zn 3.*Xn.^2 Yn.^2 Zn.^2 2*Xn.*Yn zero_m zero_m 2.*Xn.*Zn zero_m zero_m]';
du_dYn = [zero_m zero_m one_m zero_m Xn zero_m Zn zero_m 2*Yn zero_m Xn.*Zn zero_m 2.*Xn.*Yn zero_m Xn.^2 3.*Yn.^2 Zn.^2 zero_m 2.*Yn.*Zn zero_m]';
du_dZn = [zero_m zero_m zero_m one_m zero_m Xn Yn zero_m zero_m 2*Zn Xn.*Yn zero_m zero_m 2.*Xn.*Zn zero_m zero_m 2.*Yn.*Zn Xn.^2 Yn.^2 3*Zn.^2]';

AG = zeros(2*m,3*n);
scale_mat = diag([1/LONG_par(1) 1/LAT_par(1) 1/H_par(1)]);
p1 = DRPC(:,1); p2 = DRPC(:,2); p3 = DRPC(:,3); p4 = DRPC(:,4);
for i = 1:m
    for j = 1:n
        u_ = u(:,i);
        AG(2*i-1,(j-1)*3+1:j*3) = (p1'*(p2'*u_) - p2'*(p1'*u_))/(p2'*u_)^2 ...
            * [du_dXn(:,i) du_dYn(:,i) du_dZn(:,i)] * scale_mat * r_par(1);
        AG(2*i,(j-1)*3+1:j*3) = (p3'*(p4'*u_) - p4'*(p3'*u_))/(p4'*u_)^2 ...
            * [du_dXn(:,i) du_dYn(:,i) du_dZn(:,i)] * scale_mat * c_par(1);
    end
end
