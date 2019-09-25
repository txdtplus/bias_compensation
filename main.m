clear; clc; close all;
addpath('data')
addpath('read_and_write')
addpath('algorithm')
addpath('Utils')

%% read RPC and GCP
trainnum = 0;
[geoloc,real_loc,GCPnum] = readGCP('GCP_IKONOS_pan1.xlsx');
[DRPC,Normalize_par] = readrpc('RPC_IKONOS_pan1.txt','txt');

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
gcps.update_rc(cal_loc,rpc1)
delta_loc = real_loc_train - cal_loc;                 % calculate error before compensation

%% least square
A0 = gcps.gen_A12();
[coff0,L] = LSA(A0,delta_loc);

%% compensate
after_compen_loc = compensate(A0,coff0,cal_loc);
delta_loc2 =  real_loc_train - after_compen_loc;      % calculate error after compensation

%% generate vgcps(virtual ground control points)
N = 100;                                        % sqrt of number of vgcps
vgcp = gen_vgcp(N,rpc1,coff0,gcps,0);

%% caculate new RPC cofficients
DRPC_new = gen_RPC(vgcp,'d');
IRPC_new = gen_RPC(vgcp,'i');
drpc2 = RPC(DRPC_new,Normalize_par);
irpc2 = RPC(IRPC_new,Normalize_par);

%% write new RPC file
fwriteRPC('./data/new_RPC.txt',drpc2);
fwriteRPC('./data/IRPC_IKONOS_pan1.txt',irpc2);

%% check points
ckp = POINT(geoloc_check,drpc2);
ckp.update_rc(real_loc_check,rpc1);
ckp.gen_v;

cal_loc2 = drpc2.obj2img(ckp);
geo_loc2 = irpc2.img2obj(ckp);

delta_loc_geo = geoloc_check(:,2:-1:1) - geo_loc2;
delta_loc3 = real_loc_check - cal_loc2;            % calculate error before compensation

e1 = cal_error(delta_loc);
e2 = cal_error(delta_loc2);
e3 = cal_error(delta_loc3);

