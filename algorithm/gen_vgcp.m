function vgcp = gen_vgcp(N,rpc,coff,gcp,vZn)
% generate virtual ground control points as well as real gcps
%   vgcp is an object

%% generate virtual points in object space
vXn = (linspace(-0.98,0.98,N))';
vYn = (linspace(-0.98,0.98,N))';

vX = vXn * rpc.LONG_SCALE + rpc.LONG_OFF;
vY = vYn * rpc.LAT_SCALE + rpc.LAT_OFF;
vZ = vZn * rpc.H_SCALE + rpc.H_OFF;
vgeoloc = [gcp.X(1:end-7),gcp.Y(1:end-7),gcp.Z(1:end-7);vX,vY,vZ];
% vgeoloc = [vX,vY,vZ];

%% establish vgcp object
vgcp = POINT(vgeoloc,rpc);
vcal_loc = rpc.obj2img(vgcp);
vgcp.gen_rc(vcal_loc,rpc);

%% compensation
A = vgcp.gen_A();
after_compen_loc = compensate(A,coff,vcal_loc);
vgcp.update_rc(after_compen_loc,rpc);
end

