function [X,L] = LSA(A,sub)
% Least Square Adjustment
%   X = (A^T*A)^-1*A^T*L
%     [1 r1 c1 0 0  0 ]
%     [0 0  0  1 r1 c1]
% A = [1 r2 c2 0 0  0 ]
%            ...
%     [1 rm cm 0 0  0 ]
%     [0 0  0  1 rm cm]
%
% X---> (A0 A1 A2 B0 B1 B2)^T
%
%     [\Delta r_1]
%     [\Delta c_1]
% L = [\Delta r_2]
%          ...
%     [\Delta r_m]
%     [\Delta c_m]
m = size(sub,1);
L = zeros(2*m,1);
L(1:2:end-1) = sub(:,1);
L(2:2:end) = sub(:,2);
X = pinv(A)*L;
end

