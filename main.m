clear; clc; close all;
addpath('data')
addpath('read_and_write')
addpath('algorithm')
addpath('Utils')

%% read RPC and GCP
[geoloc,real_loc,GCPnum] = readGCP('GCP2.xlsx');
[DRPC,Normalize_par] = readrpc('RPC2.xml','xml');

%% generate rpc and gcp object
rpc1 = RPC(DRPC,Normalize_par);
gcps = POINT(geoloc,rpc1);

%% caculate r, c using RPC
cal_loc = rpc1.obj2img(gcps);
gcps.gen_rc(cal_loc,rpc1)
delta_loc = real_loc - cal_loc;                 % calculate error before compensation

%% least square
A0 = gcps.gen_A();
[coff0,L] = LSA(A0,delta_loc);

%% compensate
after_compen_loc = compensate(A0,coff0,cal_loc);
delta_loc2 =  real_loc - after_compen_loc;      % calculate error after compensation

%% generate vgcps(virtual ground control points)
N = 150;                                        % number of vgcps
vgcp = gen_vgcp(N-gcps.m,rpc1,coff0,gcps);

%% caculate new RPC cofficients
DRPC_new = gen_RPC(vgcp);
rpc2 = RPC(DRPC_new,Normalize_par);

%% write new RPC file
fwriteRPC('./data/new_RPC.txt',rpc2);

figure;
hold on;
plot(abs([delta_loc(:,1);delta_loc(:,2),]));
plot(abs([delta_loc2(:,1);delta_loc2(:,2)]));
hold off;
legend('before compensate','after compensate');




