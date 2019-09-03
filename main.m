clear; clc; close all;

%% read RPC and GCP
[geoloc,real_loc,GCPnum] = readGCP('GCP2.xlsx');
[DRPC,Normalize_par] = readrpc('RPC2.XML','xml');

%% generate rpc and gcp object
rpc1 = RPC(DRPC,Normalize_par);
gcps = POINT(geoloc,rpc1);

%% caculate r, c using RPC
cal_loc = rpc1.obj2img(gcps);
gcps.gen_rc(cal_loc,rpc1)
delta_loc = real_loc - cal_loc;     % calculate error before compensation

%% least square
A0 = gcps.gen_A();
[coff0,L] = LSA(A0,delta_loc);

%% compensate
after_compen_loc = compensate(A0,coff0,cal_loc);
delta_loc2 =  real_loc - after_compen_loc;   % calculate error after compensation

%% save data
save data

% %% image reading and enhancing
% [X,cmap] = imread('img.JP2');
% img1 = double(X);
% 
% low_in = 0; high_in = 1;
% low_out = 0; high_out = 1;
% gamma = 0.7;
% for i = 1:4
%     img1(:,:,i) =imadjust(X(:,:,i),[low_in high_in],[low_out, high_out],gamma);
%     img1(:,:,i) = img1(:,:,i)/max(max(img1(:,:,i)));
% end
% imshow(img1(:,:,1:3),[]);