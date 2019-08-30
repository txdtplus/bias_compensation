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
[X,Y,Z,real_loc,GCPnum] = readGCP('data//GCP2.xlsx');
[DRPC,IRPC,Normalize_par] = readrpc('data//RPC2.XML');

%% caculate r, c
r = zeros(GCPnum,1); c = zeros(GCPnum,1);
for i = 1:GCPnum   
    [r(i),c(i)] = cal_RPC(X(i),Y(i),Z(i),DRPC,Normalize_par);
end
cal_loc = [r,c];
delta_loc = real_loc - cal_loc;

%% least square
[coff,A,L] = LSA(cal_loc,delta_loc);   % use the calculated locs, not the real locs.
L_ = A*coff;
compen_loc = zeros(size(real_loc));
compen_loc(:,1) = L_(1:2:end-1);        % L denotes delta_loc,L_ denotes A*X 
                                        % which is the calculated error. 
                                        % Here should be L_, not L.
compen_loc(:,2) = L_(2:2:end);
after_compen_loc = cal_loc + compen_loc;
delta_loc2 = real_loc - after_compen_loc;

save data coff Normalize_par real_loc cal_loc DRPC X Y Z

