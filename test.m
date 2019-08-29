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
[geoloc,real_loc,GCPnum] = readGCP('data//GCP2.xlsx');
[DRPC,IRPC,Normalize_par] = readrpc('data//RPC2.XML');

% RPC1 = RPC(DRPC,Normalize_par);
% [r,c] = RPC1.obj2img(geoloc);
gcps = GCPs(geoloc,IRPC,Normalize_par);
r = gcps.r;
c = gcps.c;
% %% caculate r, c
% r = zeros(GCPnum,1); c = zeros(GCPnum,1);
% for i = 1:GCPnum   
%     [r(i),c(i)] = cal_RPC(geoloc(i,1),geoloc(i,2),geoloc(i,3),DRPC,Normalize_par);
% end
% cal_loc = [r,c];
% delta_loc = real_loc - cal_loc;
% % 
% %% least square
% [coff,A,L] = LSA(real_loc,delta_loc);
% L_ = A*coff;
% compen_loc = zeros(size(real_loc));
% compen_loc(:,1) = L(1:2:end-1);
% compen_loc(:,2) = L(2:2:end);
% after_compen_loc = cal_loc + compen_loc;
% delta_loc2 = real_loc - after_compen_loc;
% 
% save data coff Normalize_par real_loc cal_loc DRPC geoloc

