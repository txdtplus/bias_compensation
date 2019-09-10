classdef IRPC < handle
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
        function obj = RPC(IRPC,Normalize_par)
            %DRPC should be a matrix :[20, 4]
            %   Normalize_par should be a matrix : [2, 5]
            obj.p1 = IRPC(:,1);
            obj.p2 = IRPC(:,2);
            obj.p3 = IRPC(:,3);
            obj.p4 = IRPC(:,4);
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
        
        function drpc = gen_drpc(obj)
            drpc = zeros(20,4);
            drpc(:,1) = obj.p1;
            drpc(:,2) = obj.p2;
            drpc(:,3) = obj.p3;
            drpc(:,4) = obj.p4;
        end
        
        function npar = gen_npar(obj)
            npar = zeros(2,5);
            npar(1,1) = obj.LONG_SCALE;
            npar(2,1) = obj.LONG_OFF;
            npar(1,2) = obj.LAT_SCALE;
            npar(2,2) = obj.LAT_OFF;
            npar(1,3) = obj.H_SCALE;
            npar(2,3) = obj.H_OFF;
            npar(1,4) = obj.LINE_SCALE;
            npar(2,4) = obj.LINE_OFF;
            npar(1,5) = obj.SAMP_SCALE;
            npar(2,5) = obj.SAMP_OFF;
        end
        
        function geo_loc = img2obj(obj,GEOPOINT)
            % map from geographic coordinates to image coordinates
            %   POINT is a class
            
            u = IMGPOINT.u;
            Yn_ = obj.p1'*u./(obj.p2'*u);
            Xn_ = obj.p3'*u./(obj.p4'*u);
            
            Y_ = Yn_ * obj.LAT_SCALE + obj.LAT_OFF;
            X_ = Xn_ * obj.LONE_SCALE + obj.LONE_OFF;
            
            Y_ = Y_'; X_ = X_';
            geo_loc = [Y_,X_];
        end
    end
end

