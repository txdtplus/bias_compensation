clear; clc; close all;

%% read RPC and GCP
[geoloc,real_loc,GCPnum] = readGCP('GCP2.xlsx');
[DRPC,Normalize_par] = readrpc('RPC2.XML','xml');

gcps = POINT(geoloc,DRPC,Normalize_par);
rpc1 = RPC(DRPC,Normalize_par);

cal_loc = rpc1.obj2img(gcps);
delta_loc = real_loc - cal_loc; 
%% least square
[coff0,A0,L] = LSA(cal_loc,delta_loc);
L_ = A0*coff0;
compen_loc = zeros(size(real_loc));
compen_loc(:,1) = L_(1:2:end-1);
compen_loc(:,2) = L_(2:2:end);
after_compen_loc = cal_loc + compen_loc;
delta_loc2 = real_loc - after_compen_loc;

save data

