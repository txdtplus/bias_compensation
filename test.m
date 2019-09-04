clear; clc; close all;
load data

rpc2 = RPC(DRPC_new,Normalize_par);
gcps = POINT(geoloc,rpc2);

%% caculate r, c using RPC
cal_loc_new = rpc2.obj2img(gcps);
gcps.gen_rc(cal_loc_new,rpc2)
delta_loc3 = real_loc - cal_loc_new;                 % calculate error before compensation