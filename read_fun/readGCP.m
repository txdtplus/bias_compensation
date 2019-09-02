function [geoloc,real_loc,GCPnum] = readGCP(filename)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
GCPmat = xlsread(filename);
GCPnum = size(GCPmat,1);
real_loc = GCPmat(:,1:2);
X = GCPmat(:,3);
Y = GCPmat(:,4);
Z = GCPmat(:,5);

geoloc = [X,Y,Z];
end

