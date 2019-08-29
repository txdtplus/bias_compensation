function [outputArg1,outputArg2] = iterLSA(coff0,N_par,real_loc,cal_loc,DRPC,X,Y,Z)
%caculate iterated least square adjustment
%   coff0: original cofficient caculated before
%   N_par: parameters for normalization e.g. LONG_SCALE, LONG_OFF etc.
%   real_loc: real locations from GCP
%   DRPC: RPC cofficients, 
%       r = p1(X,Y,Z)/p2(X,Y,Z)
%       c = p3(X,Y,Z)/p4(X,Y,Z)

m = size(real_loc,1);
r = real_loc(:,1); cal_r = cal_loc(:,1);
c = real_loc(:,2); cal_c = cal_loc(:,2);
F0_1 = zeros(2*m,10);
F0_2 = zeros(10,1);

F0_2(1) = -1; F0_2(2:4) = coff0(1:3); F0_2(5) = 1;
F0_2(1) = -1; F0_2(2:4) = coff0(4:6); F0_2(5) = 1;

for i = 1:2:m
    F0_1(i,1) = r(i);
    F0_1(i,2) = 1;
    F0_1(i,3) = c(i);
    F0_1(i,4) = r(i);
    F0_1(i,5) = cal_r(i);
    
    F0_1(i+1,6) = c(i);
    F0_1(i+1,7) = 1;
    F0_1(i+1,8) = c(i);
    F0_1(i+1,9) = r(i);
    F0_1(i+1,10) = cal_c(i);
end
w = -F0_1*F0_2;
end

