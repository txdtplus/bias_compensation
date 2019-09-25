function RPC = gen_RPC(vgcp,mode)
%generate new RPC using gcps
%   vgcp is vitual gcp
m = vgcp.m;

if strcmp(mode,'d')
    R = vgcp.rn;
    C = vgcp.cn;
    u = (vgcp.u)';
else
    R = vgcp.Yn;
    C = vgcp.Xn;
    u = (vgcp.v)';
end
M = [u,u(:,2:end).*repmat(-R,1,19)];
N = [u,u(:,2:end).*repmat(-C,1,19)];
T = [M,zeros(size(M)); zeros(size(M)),N];
G = [R;C];

W = eye(2*m);
error = 1;
i = 0;
while(error(end)>0.9)
    Q = pinv(W*T)*W*G;
    B = u*[1;Q(21:39)];
    D = u*[1;Q(60:78)];
    W = diag([1./B',1./D']);
    V = W*T*Q - W*G;
    i = i + 1
    error(i) = norm(V);
end
figure;
plot(error);
grid on;
title('iteration error');
xlabel('iteration number');
ylabel('iteration');
p1 = Q(1:20);   p2 = [1;Q(21:39)];
p3 = Q(40:59);   p4 = [1;Q(60:78)];
RPC = [p1,p2,p3,p4];
end

