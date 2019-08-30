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
% 
% for iter = 1:1
%     xA = x(1:6);
%     F0_2(1) = -1; F0_2(2:4) = xA(1:3); F0_2(5) = 1;
%     F0_2(6) = -1; F0_2(7:9) = xA(4:6); F0_2(10) = 1;
%     
%     for i = 1:2:2*m
%         F0_1(i,1) = r((i+1)/2);
%         F0_1(i,2) = 1;
%         F0_1(i,3) = r((i+1)/2);
%         F0_1(i,4) = c((i+1)/2);
%         F0_1(i,5) = cal_r((i+1)/2);
%         
%         F0_1(i+1,6) = c((i+1)/2);
%         F0_1(i+1,7) = 1;
%         F0_1(i+1,8) = r((i+1)/2);
%         F0_1(i+1,9) = c((i+1)/2);
%         F0_1(i+1,10) = cal_c((i+1)/2);
%     end
%     wp = -F0_1*F0_2;
%     wA = zeros(3*n,1);
%     wG = zeros(6*n,1);
%     w = [wp;wA;wG];
%     
%     dx = pinv(A)*w;
%     x = x + dx;
% end