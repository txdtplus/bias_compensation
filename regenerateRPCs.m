% function [RPCs] = regenerateRPCs(GCPs,iters)
% input:  GCPs---GCP, at least 39
%                GCP should be in this form: r c longitudu latitude high
%         iters--upper limit of iteration number
% output: RPCs---the new RPCs

[x,y,z,real_loc,GCPnum] = readGCP('data//GCP2.xlsx');
iters = 20;
GCPs = [real_loc x y z];

GCP_num = size(GCPs, 1);
RPCs = ones(20,4);
% a = RPCs(:,1);
% b = RPCs(:,2);
% c = RPCs(:,3);
% d = RPCs(:,4);
% diag(n,k)   k=0
R = GCPs(:, 1);    % row
C = GCPs(:, 2);    % col
X = GCPs(:, 3);    % longitudu
Y = GCPs(:, 4);    % latitude
Z = GCPs(:, 5);    % high

n = zeros(GCP_num,20);
n(:,1) = ones(GCP_num,1);     n(:, 2) = X;    n(:,3) = Y;   n(:,4) = Z;
n(:,5) = X.*Y; n(:,6) = X.*Z; n(:, 7) = Y.*Z;    n(:,8) = X.^2;
n(:, 9) = Y.^2;  n(:, 10) = Z.^2; n(:, 11) = X.*Y.*Z; n(:, 12) = X.^3;
n(:, 13) = X.*Y.^2; n(:,14) = X.*Z.^2; n(:,15) = X.^2.*Y; n(:,16) = Y.^3;
n(:,17) = Y.*Z.^2; n(:,18) = X.^2.*Z; n(:,19) = Y.^2.*Z;  n(:,20) = Z.^3;

temr = -repmat(R, [1,19]);
M = [n temr.*n(:,2:20)]; % M
temr = -repmat(C, [1,19]);
N = [n temr.*n(:,2:20)]; % N
T = [M zeros(GCP_num,39); zeros(GCP_num,39) N];  % T

G = [R; C];  % G

% the first iteration: let W be a unit matrix
W = eye(2*GCP_num);

i = 0;
while(i<iters)
    i = i + 1;
    % calculate Q
    Q = pinv(W*T)*W*G;    % LSA AX=L
%     Q = (T'*W'*W*T)\T'*W'*W*G;
    V = W*T*Q - W*G;
    error = norm(V, 2)
%     if error < 0.5
%         break;
%     end
    % calculate W
    b = [1; Q(21:39)];
    d = [1; Q(60:78)];
    B_W = 1 ./ (n*b);      % 1/B
    D_W = 1 ./ (n*d);      % 1/D
    W_v = [B_W; D_W];
    W = diag(W_v,0);       % W
end

% Q = [a; b; c; d];        % Q


% end