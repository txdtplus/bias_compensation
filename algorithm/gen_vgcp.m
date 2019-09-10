function vgcp = gen_vgcp(N,rpc,coff,gcp,mode)
% generate virtual ground control points as well as real gcps
%   vgcp is an object
%   mode == 1: using vgcp and real gcps
%   mode == 0: using vgcp only

%% generate virtual points in object space
vXn = (linspace(-0.98,0.98,N))';
vYn = (linspace(-0.98,0.98,N))';
vZn = 0.01*ones(N^2,1);

vX = vXn * rpc.LONG_SCALE + rpc.LONG_OFF;
vY = vYn * rpc.LAT_SCALE + rpc.LAT_OFF;
vZ = vZn * rpc.H_SCALE + rpc.H_OFF;

vgeoloc = zeros(N^2,3);
for i = 1:N
    vgeoloc((i-1)*N+1:i*N,1) = vX(i);
    vgeoloc((i-1)*N+1:i*N,2) = vY;
end
vgeoloc(:,3) = vZ;
if mode == 1
    geoloc = [gcp.X,gcp.Y,gcp.Z;vgeoloc];
else
    geoloc = vgeoloc;
end

%% establish vgcp object
vgcp = POINT(geoloc,rpc);
vcal_loc = rpc.obj2img(vgcp);
vgcp.gen_rc(vcal_loc,rpc);

%% compensation
A = vgcp.gen_A12();
after_compen_loc = compensate(A,coff,vcal_loc);
vgcp.update_rc(after_compen_loc,rpc);
end

