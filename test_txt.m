clear; clc; close all;

rpc_file = fopen('RPC1.txt');
rpc = textscan(rpc_file,'%s %f32 %s');
fclose(rpc_file);

line_off = rpc{2}(1);   line_scale = rpc{2}(6);
samp_off = rpc{2}(2);   samp_scale = rpc{2}(7);
lat_off = rpc{2}(3);    lat_scale = rpc{2}(8);
long_off = rpc{2}(4);   long_scale = rpc{2}(9);
height_off = rpc{2}(5); height_scale = rpc{2}(10);

n_par = zeros(2,5);
DRPC = zeros(20,4);

n_par(1,:) = [long_scale,lat_scale,height_scale,line_scale,samp_scale];
n_par(2,:) = [long_off,lat_off,height_off,line_off,samp_off];

DRPC(:,1) = rpc{2}(11:30);  DRPC(:,2) = rpc{2}(31:50);
DRPC(:,3) = rpc{2}(51:70);  DRPC(:,4) = rpc{2}(71:90);


