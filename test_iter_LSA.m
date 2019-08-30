clear; clc; close all;
load data
xA = coff0;
xG = [0;0;0];
x = [xA;xG];
gcps = POINT(geoloc,real_loc,DRPC,Normalize_par);
rpc1 = RPC(DRPC,Normalize_par);

%% ini
n = 1;   % image number
m = gcps.m;
r = gcps.r; cal_r = cal_loc(:,1);
c = gcps.r; cal_c = cal_loc(:,2);

%% caculate A

[dr,dc] = rpc1.par_diff(gcps);
AG = zeros(2*m,3*n);    AA = A0;
for i = 1:m
    for j = 1:n
        AG(2*i-1,3*(j-1)+1:3*j) = dr(i,:);
        AG(2*i,3*(j-1)+1:3*j) = dc(i,:);
        %         AA(:,6*(j-1)+1:6*j) = A0;
    end
end
A = [AA,AG];
A = [A;eye(9*n)];

%% caculate w
% F0_1 = zeros(2*m,10);
% F0_2 = zeros(10,1);
wp = zeros(2*m,1);
for iter = 1:100
    xA = x(1:6);
    L_ = A0*xA;
    compen_loc = zeros(size(real_loc));
    compen_loc(:,1) = L_(1:2:end-1);
    compen_loc(:,2) = L_(2:2:end);
    after_compen_loc = cal_loc + compen_loc;
    delta_loc2 = real_loc - after_compen_loc;
    for i = 1:m
        wp(2*i-1) = delta_loc2(i,1);
        wp(2*i) = delta_loc2(i,2);
    end
    wA = zeros(3*n,1);
    wG = zeros(6*n,1);
    w = [wp;wA;wG];
    
    dx = pinv(A)*w;
    x = x + dx;
end