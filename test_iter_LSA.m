clear; clc; close all;
load data
coff0 = coff;
gcps = POINT(geoloc,real_loc,DRPC,Normalize_par);
rpc1 = RPC(DRPC,Normalize_par);

%% caculate w
n = 1;   % image number
m = gcps.m;
r = gcps.r; cal_r = cal_loc(:,1);
c = gcps.r; cal_c = cal_loc(:,2);
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

[dr,dc] = rpc1.par_diff(gcps);
