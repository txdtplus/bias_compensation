clear; clc; close all;
 
% %% read images
% tic
% image = imread('data//1.JP2');
% toc
% imgRGB = image(:,:,1:3);
% 
% %% image enhancing
% low_in = 0; high_in = 1;
% low_out = 0; high_out = 1;
% gamma = 0.7;
% img2 =imadjust(imgRGB,[low_in high_in],[low_out, high_out],gamma);
% imshow(img2);

%% read RPC and GCP
[geoloc,real_loc,GCPnum] = readGCP('GCP2.xlsx');
[DRPC,Normalize_par] = readrpc('RPC2.XML','xml');

gcps = POINT(geoloc,real_loc,DRPC,Normalize_par);
rpc1 = RPC(DRPC,Normalize_par);

cal_loc = rpc1.obj2img(gcps);
delta_loc = real_loc - cal_loc; 
%% least square
[coff0,A0,L] = LSA(real_loc,delta_loc);
L_ = A0*coff0;
compen_loc = zeros(size(real_loc));
compen_loc(:,1) = L_(1:2:end-1);
compen_loc(:,2) = L_(2:2:end);
after_compen_loc = cal_loc + compen_loc;
delta_loc2 = real_loc - after_compen_loc;

save data coff0 Normalize_par real_loc cal_loc DRPC geoloc A0 delta_loc2

