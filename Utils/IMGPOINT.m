classdef IMGPOINT < handle
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
    %   IRPC is a class for map from object space to image space.
    
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
        function obj = IMGPOINT(ImglocAndZ,IRPC)
            % geoloc should be a [m,3] matrix.
            %   geoloc(:,1) is the longitude of GCPs.
            %   geoloc(:,2) is the latitude of GCPs.
            %   geoloc(:,3) is the height of GCPs.
            % DRPC should be a [20,4] matrix.
            % Normalize_par should be a [2,5] matrix.
            obj.m = size(ImglocAndZ,1);
            
            obj.c =  ImglocAndZ(:,1);
            obj.r = ImglocAndZ(:,2);
            obj.Z = ImglocAndZ(:,3);
            
            obj.cn = (obj.c-IRPC.SAMP_OFF)/IRPC.SAMP_SCALE;
            obj.rn = (obj.r-IRPC.LINE_OFF)/IRPC.LINE_SCALE;
            obj.Zn = (obj.Z-IRPC.H_OFF)/IRPC.H_SCALE;
            
            obj.Y = zeros(obj.m,1);
            obj.X = zeros(obj.m,1);
            obj.Yn = zeros(obj.m,1);
            obj.Xn = zeros(obj.m,1);
            
            obj.u = zeros(obj.m,20);
            obj.u(:,1) = ones(obj.m,1);             obj.u(:,2) = obj.cn;
            obj.u(:,3) = obj.rn;                    obj.u(:,4) = obj.Zn;
            obj.u(:,5) = obj.cn.*obj.rn;            obj.u(:,6) = obj.cn.*obj.Zn;
            obj.u(:,7) = obj.rn.*obj.Zn;            obj.u(:,8) = obj.cn.^2;
            obj.u(:,9) = obj.rn.^2;                 obj.u(:,10) = obj.Zn.^2;
            obj.u(:,11) = obj.cn.*obj.rn.*obj.Zn;	obj.u(:,12) = obj.cn.^3;
            obj.u(:,13) = obj.cn.*obj.rn.^2;        obj.u(:,14) = obj.cn.*obj.Zn.^2;
            obj.u(:,15) = obj.cn.^2.*obj.rn;        obj.u(:,16) = obj.rn.^3;
            obj.u(:,17) = obj.rn.*obj.Zn.^2;        obj.u(:,18) = obj.cn.^2.*obj.Zn;
            obj.u(:,19) = obj.rn.^2.*obj.Zn;        obj.u(:,20) = obj.Zn.^3;
            
            obj.u = obj.u';
        end
        
        function gen_yx(obj,geo_loc,IRPC)
            obj.Y = geo_loc(:,1);
            obj.X = geo_loc(:,2);
            obj.Yn = (obj.Y-IRPC.LAT_OFF)/IRPC.LAT_SCALE;
            obj.Xn = (obj.X-IRPC.LONE_OFF)/IRPC.LONE_SCALE;
        end
        
        function A = gen_A(obj)
            m_ = obj.m;
            A = zeros(2*m_,6);
            for i = 1:m_
                A(2*i-1,1) = 1;
                A(2*i-1,2) = obj.Yn(i);
                A(2*i-1,3) = obj.Xn(i);
                A(2*i,4) = 1;
                A(2*i,5) = obj.Yn(i);
                A(2*i,6) = obj.Xn(i);
            end
        end
        
        function A12 = gen_A12(obj)
            m_ = obj.m;
            A12 = zeros(2*m_,12);
            for i = 1:m_
                A12(2*i-1,1) = 1;
                A12(2*i-1,2) = obj.Yn(i);
                A12(2*i-1,3) = obj.Xn(i);
                A12(2*i-1,4) = (obj.Yn(i)).^2;
                A12(2*i-1,5) = obj.Yn(i).*obj.Xn(i);
                A12(2*i-1,6) = (obj.Xn(i)).^2;
                
                A12(2*i,7) = 1;
                A12(2*i,8) = obj.Yn(i);
                A12(2*i,9) = obj.Xn(i);
                A12(2*i,10) = (obj.Yn(i)).^2;
                A12(2*i,11) = obj.Yn(i).*obj.Xn(i);
                A12(2*i,12) = (obj.Xn(i)).^2;
            end
        end
        
        function update_YX(obj,new_YX,IRPC)
            obj.Y = new_YX(:,1);
            obj.X = new_YX(:,2);
            obj.Yn = (obj.Y-IRPC.LAT_OFF)/IRPC.LAT_SCALE;
            obj.Xn = (obj.X-IRPC.LONE_OFF)/IRPC.LONE_SCALE;
        end
    end
end

