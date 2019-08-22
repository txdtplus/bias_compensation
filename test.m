clear; clc; close all;
 
% %% 读取图像
% tic
% image = imread('data//1.JP2');
% toc
% imgRGB = image(:,:,1:3);
% 
% %% 图像增强
% low_in = 0; high_in = 1;
% low_out = 0; high_out = 1;
% gamma = 0.7;
% img2 =imadjust(imgRGB,[low_in high_in],[low_out, high_out],gamma);
% imshow(img2);

%% 读取RPC和GCP
[X,Y,Z,real_loc,GCPnum] = readGCP('data//GCP2.xlsx');
[DRPC,IRPC,Normalize_par] = readrpc('data//RPC2.XML');

%% 计算r, c, 误差
r = zeros(GCPnum,1); c = zeros(GCPnum,1);
for i = 1:GCPnum   
    [r(i),c(i)] = cal_RPC(X(i),Y(i),Z(i),DRPC,Normalize_par);
end
cal_loc = [r,c];
sub = cal_loc - real_loc;

%% 最小二乘平差
[coff,A,L] = LSA(real_loc,sub);
% nnnnn
% figure;dddd
% hold on;
% plot(L,'*');
% plot(A*coff);
% hold off;
% grid on;

% figure;
% hold on;
% axis([0 18609 0 22901]);
% for i = 1:size(real_loc,1)
%     F = plot([real_loc(i,2),cal_loc(i,2)],[real_loc(i,1),cal_loc(i,1)],'-*');
%     set(F,'color','black');
% end
% hold off;
% grid on;  xiaohuaidan
% zky
%tttt


