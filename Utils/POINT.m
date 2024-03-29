classdef POINT < handle
    %points coordinates
    %   X is the longitude of point in object space.
    %   Y is the latitude of point in object space.
    %   Z is the height of point in object space.
    %
    %   Xn is the normalized longitude of point in object space.
    %   Yn is the normalized latitude of point in object space.
    %   Zn is the normalized height of point in object space.
    %
    %   r is the line index of point in image space.
    %   c is the latitude of point in image space.
    %   rn is the normalized line index of point in image space.
    %   cn is the normalized latitude of point in image space.
    %
    %   u is a [20,m] matrix, every column of u is polynomial for
    %   calucating RPC. The polynomial cofficients are obj.p1, p2, p3
    %   and p4.
    %
    %   m is the number of points.
    %   RPC is a class for map from object space to image space.
    
    properties
        X
        Y
        Z
        Xn
        Yn
        Zn
        
        r
        c
        rn
        cn
        
        u
        m
    end
    
    methods
        function obj = POINT(geoloc,RPC)
            % geoloc should be a [m,3] matrix.
            %   geoloc(:,1) is the longitude of GCPs.
            %   geoloc(:,2) is the latitude of GCPs.
            %   geoloc(:,3) is the height of GCPs.
            % DRPC should be a [20,4] matrix.
            % Normalize_par should be a [2,5] matrix.
            obj.m = size(geoloc,1);
            
            obj.X =  geoloc(:,1);
            obj.Y = geoloc(:,2);
            obj.Z = geoloc(:,3);
            
            obj.Xn = (obj.X-RPC.LONG_OFF)/RPC.LONG_SCALE;
            obj.Yn = (obj.Y-RPC.LAT_OFF)/RPC.LAT_SCALE;
            obj.Zn = (obj.Z-RPC.H_OFF)/RPC.H_SCALE;
            
            obj.r = zeros(obj.m,1);
            obj.c = zeros(obj.m,1);
            obj.rn = zeros(obj.m,1);
            obj.cn = zeros(obj.m,1);
            
            obj.u = zeros(obj.m,20);
            obj.u(:,1) = ones(obj.m,1);             obj.u(:,2) = obj.Xn;
            obj.u(:,3) = obj.Yn;                    obj.u(:,4) = obj.Zn;
            obj.u(:,5) = obj.Xn.*obj.Yn;            obj.u(:,6) = obj.Xn.*obj.Zn;
            obj.u(:,7) = obj.Yn.*obj.Zn;            obj.u(:,8) = obj.Xn.^2;
            obj.u(:,9) = obj.Yn.^2;                 obj.u(:,10) = obj.Zn.^2;
            obj.u(:,11) = obj.Xn.*obj.Yn.*obj.Zn;	obj.u(:,12) = obj.Xn.^3;
            obj.u(:,13) = obj.Xn.*obj.Yn.^2;        obj.u(:,14) = obj.Xn.*obj.Zn.^2;
            obj.u(:,15) = obj.Xn.^2.*obj.Yn;        obj.u(:,16) = obj.Yn.^3;
            obj.u(:,17) = obj.Yn.*obj.Zn.^2;        obj.u(:,18) = obj.Xn.^2.*obj.Zn;
            obj.u(:,19) = obj.Yn.^2.*obj.Zn;        obj.u(:,20) = obj.Zn.^3;
            
            obj.u = obj.u';
        end
        
        function gen_rc(obj,cal_loc,RPC)
            obj.r = cal_loc(:,1);
            obj.c = cal_loc(:,2);
            obj.rn = (obj.r-RPC.LINE_OFF)/RPC.LINE_SCALE;
            obj.cn = (obj.c-RPC.SAMP_OFF)/RPC.SAMP_SCALE;
        end
        
        function A = gen_A(obj)
            m_ = obj.m;
            A = zeros(2*m_,6);
            for i = 1:m_
                A(2*i-1,1) = 1;
                A(2*i-1,2) = obj.r(i);
                A(2*i-1,3) = obj.c(i);
                A(2*i,4) = 1;
                A(2*i,5) = obj.r(i);
                A(2*i,6) = obj.c(i);
            end
        end
        
        function update_rc(obj,new_rc,RPC)
            obj.r = new_rc(:,1);
            obj.c = new_rc(:,2);
            obj.rn = (obj.r-RPC.LINE_OFF)/RPC.LINE_SCALE;
            obj.cn = (obj.c-RPC.SAMP_OFF)/RPC.SAMP_SCALE;
        end
    end
end

