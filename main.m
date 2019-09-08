clear; clc; close all;
addpath('data')
addpath('read_and_write')
addpath('algorithm')
addpath('Utils')

%% read RPC and GCP
[geoloc,real_loc,GCPnum] = readGCP('GCP3.xlsx');
[DRPC,Normalize_par] = readrpc('new_RPC.txt','txt');

%% generate rpc and gcp object
rpc1 = RPC(DRPC,Normalize_par);
gcps = POINT(geoloc,rpc1);

%% caculate r, c using RPC
cal_loc = rpc1.obj2img(gcps);
gcps.gen_rc(cal_loc,rpc1)
delta_loc = real_loc - cal_loc;                 % calculate error before compensation

%% least square
A0 = gcps.gen_A12();
[coff0,L] = LSA(A0,delta_loc);

%% compensate
after_compen_loc = compensate(A0,coff0,cal_loc);
delta_loc2 =  real_loc - after_compen_loc;      % calculate error after compensation

%% generate vgcps(virtual ground control points)
N = 150;                                        % number of vgcps
imax = 9;
% vZn = (randi(9,N,1)-5)/5';
vZn = (1.9*rand(1,N)-0.95)';
vgcp = gen_vgcp(N,rpc1,coff0,gcps,vZn);

%% caculate new RPC cofficients
DRPC_new = gen_RPC(vgcp);
rpc2 = RPC(DRPC_new,Normalize_par);

%% write new RPC file
fwriteRPC('./data/new_RPC.txt',rpc2);




