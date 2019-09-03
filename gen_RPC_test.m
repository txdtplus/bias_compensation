clear; clc; close all;
load vgcp

%%
m = vgcp.m;
R = vgcp.rn;    
C = vgcp.rn;
u = (vgcp.u)';
M = [u,u(:,2:end).*repmat(-R,1,19)];
N = [u,u(:,2:end).*repmat(-C,1,19)];
T = [M,zeros(size(M)); zeros(size(M)),N];
G = [R;C];

W = eye(2*m);
max_iter_num = 100;
error = zeros(1,max_iter_num);
for i = 1:max_iter_num
    Q = pinv(W*T)*W*G;
    B = u*[1;Q(21:39)];
    D = u*[1;Q(60:78)];
    W = diag([1./B',1./D']);
    V = W*T*Q - W*G;
    error(i) = norm(V);
end