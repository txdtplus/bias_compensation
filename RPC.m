classdef RPC < handle
    %RPC is a RPC object.
    %
    %
    %
    %
    %
    %
    %
    %
    %
    
    properties
        p1
        p2
        p3
        p4
        LONG_SCALE
        LONG_OFF
        LAT_SCALE
        LAT_OFF
        H_SCALE
        H_OFF
        LINE_SCALE
        LINE_OFF
        SAMP_SCALE
        SAMP_OFF
    end
    
    methods
        function obj = RPC(DRPC,Normalize_par)
            %DRPC should be a matrix :[20, 4]
            %   Normalize_par should be a matrix : [2, 5]
            obj.p1 = DRPC(:,1);
            obj.p2 = DRPC(:,2);
            obj.p3 = DRPC(:,3);
            obj.p4 = DRPC(:,4);
            obj.LONG_SCALE = Normalize_par(1,1);
            obj.LONG_OFF = Normalize_par(2,1);
            obj.LAT_SCALE = Normalize_par(1,2);
            obj.LAT_OFF = Normalize_par(2,2);
            obj.H_SCALE = Normalize_par(1,3);
            obj.H_OFF = Normalize_par(2,3);
            obj.LINE_SCALE = Normalize_par(1,4);
            obj.LINE_OFF = Normalize_par(2,4);
            obj.SAMP_SCALE = Normalize_par(1,5);
            obj.SAMP_OFF = Normalize_par(2,5);
        end
        
        function u = obj2poly(obj,POINTs)
            % geoloc should be a [m,3] matrix.
            % u is a [20,m] matrix, every column of u is polynomial for
            % calucating RPC. The polynomial cofficients are obj.p1, p2, p3
            % and p4.
            %
            %   m is the number of GCPs.
            %   geoloc(:,1) is the longitude of GCPs.
            %   geoloc(:,2) is the latitude of GCPs.
            %   geoloc(:,3) is the height of GCPs.
            m = size(geoloc,1);
            X = geoloc(:,1);
            Y = geoloc(:,2);
            Z = geoloc(:,3);
            
            Xn = (X-obj.LONG_OFF)/obj.LONG_SCALE;
            Yn = (Y-obj.LAT_OFF)/obj.LAT_SCALE;
            Zn = (Z-obj.H_OFF)/obj.H_SCALE;
            
            u = zeros(m,20);
            u(:,1) = ones(m,1);     u(:,2) = Xn;            u(:,3) = Yn;            u(:,4) = Zn;
            u(:,5) = Xn.*Yn;        u(:,6) = Xn.*Zn;        u(:,7) = Yn.*Zn;        u(:,8) = Xn.^2;
            u(:,9) = Yn.^2;         u(:,10) = Zn.^2;        u(:,11) = Xn.*Yn.*Zn;	u(:,12) = Xn.^3;
            u(:,13) = Xn.*Yn.^2;    u(:,14) = Xn.*Zn.^2;    u(:,15) = Xn.^2.*Yn;	u(:,16) = Yn.^3;
            u(:,17) = Yn.*Zn.^2;	u(:,18) = Xn.^2.*Zn;    u(:,19) = Yn.^2.*Zn;	u(:,20) = Zn.^3;
            
            u = u';
        end
        
        function [r,c] = obj2img(obj,geoloc)
            %map from geographic coordinates to image coordinates
            %   rn, cn are normalized image coordinates
            %   % geoloc should be a [m,3] matrix.
            u = obj.obj2poly(geoloc);
            rn = obj.p1'*u./(obj.p2'*u);
            cn = obj.p1'*u./(obj.p2'*u);
            
            r = rn * obj.LINE_SCALE + obj.LINE_OFF;
            c = cn * obj.SAMP_SCALE + obj.SAMP_OFF;
            
            r = r'; c = c';
        end
        
%         function [dr,dc] = par_diff(obj,geoloc)
%             
%         end
    end
end

