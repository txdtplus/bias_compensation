clear; clc; close all;
addpath('data')
addpath('read_and_write')
addpath('algorithm')
addpath('Utils')

%% read RPC and GCP
trainnum = 30;
[geoloc,real_loc,GCPnum] = readGCP('GCP2.xlsx');
[DRPC,Normalize_par] = readrpc('RPC2.xml','xml');

%% train and check points
geoloc_train = geoloc(1:trainnum,:);
real_loc_train = real_loc(1:trainnum,:);

geoloc_check = geoloc(trainnum+1:end,:);
real_loc_check = real_loc(trainnum+1:end,:);

% geoloc_check = geoloc(1:trainnum,:);
% real_loc_check = real_loc(1:trainnum,:);

%% generate rpc and gcp object
rpc1 = RPC(DRPC,Normalize_par);
gcps = POINT(geoloc_train,rpc1);

%% caculate r, c using RPC
cal_loc = rpc1.obj2img(gcps);
gcps.gen_rc(cal_loc,rpc1)
delta_loc = real_loc_train - cal_loc;                 % calculate error before compensation

%% least square
A0 = gcps.gen_A();
[coff0,L] = LSA(A0,delta_loc);

%% compensate
after_compen_loc = compensate(A0,coff0,cal_loc);
delta_loc2 =  real_loc_train - after_compen_loc;      % calculate error after compensation

%% generate vgcps(virtual ground control points)
N = 10;                                        % sqrt of number of vgcps
vgcp = gen_vgcp(N,rpc1,coff0,gcps,1);

%% caculate new RPC cofficients
DRPC_new = gen_RPC(vgcp);
rpc2 = RPC(DRPC_new,Normalize_par);

%% write new RPC file
fwriteRPC('./data/new_RPC.txt',rpc2);

%% check points
ckp = POINT(geoloc_check,rpc2);
cal_loc2 = rpc2.obj2img(ckp);
delta_loc3 = real_loc_check - cal_loc2;            % calculate error before compensation



