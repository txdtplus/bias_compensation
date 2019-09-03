clear; clc; close all;

load data rpc1 geoloc
N = 100;
vXn = (linspace(-0.98,0.98,N))';
vYn = (linspace(-0.98,0.98,N))';
vZn = (1.9*rand(1,N)-0.95)';

vX = vXn * rpc1.LONG_SCALE + rpc1.LONG_OFF;
vY = vYn * rpc1.LAT_SCALE + rpc1.LAT_OFF;
vZ = vZn * rpc1.H_SCALE + rpc1.H_OFF;
vgeoloc = [vX,vY,vZ];

vgcp = POINT(vgeoloc,rpc1);
cal_loc = rpc1.obj2img(vgcp);
vgcp.gen_rc(cal_loc,rpc1);