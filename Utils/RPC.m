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
        
        function cal_loc = obj2img(obj,POINT)
            % map from geographic coordinates to image coordinates
            %   POINT is a class
            
            u = POINT.u;
            rn_ = obj.p1'*u./(obj.p2'*u);
            cn_ = obj.p3'*u./(obj.p4'*u);
            
            r_ = rn_ * obj.LINE_SCALE + obj.LINE_OFF;
            c_ = cn_ * obj.SAMP_SCALE + obj.SAMP_OFF;
            
            r_ = r_'; c_ = c_';
            cal_loc = [r_,c_];
        end
        
        function [dr,dc] = par_diff(obj,p)
            m = p.m;
            zero_m = zeros(m,1);
            one_m = ones(m,1);
            du_dXn = [zero_m one_m zero_m zero_m p.Yn...
                p.Zn zero_m 2*p.Xn zero_m zero_m...
                p.Yn.*p.Zn 3.*p.Xn.^2 p.Yn.^2 p.Zn.^2 2*p.Xn.*p.Yn...
                zero_m zero_m 2.*p.Xn.*p.Zn zero_m zero_m]';
            du_dYn = [zero_m zero_m one_m zero_m p.Xn...
                zero_m p.Zn zero_m 2*p.Yn zero_m...
                p.Xn.*p.Zn zero_m 2.*p.Xn.*p.Yn zero_m p.Xn.^2 ...
                3*p.Yn.^2 p.Zn.^2 zero_m 2.*p.Yn.*p.Zn zero_m]';
            du_dZn = [zero_m zero_m zero_m one_m zero_m...
                p.Xn p.Yn zero_m zero_m 2*p.Zn...
                p.Xn.*p.Yn zero_m zero_m 2.*p.Xn.*p.Zn zero_m...
                zero_m 2.*p.Yn.*p.Zn p.Xn.^2 p.Yn.^2 3*p.Zn.^2]';
            
            u = p.u;
            scale_mat = diag([1/obj.LONG_SCALE 1/obj.LAT_SCALE 1/obj.H_SCALE]);
            dr =zeros(m,3);
            dc =zeros(m,3);
            for i = 1:m
                u_ = u(:,i);
                dr(i,:) = (obj.p1'*(obj.p2'*u_) - obj.p2'*(obj.p1'*u_))/(obj.p2'*u_)^2 ...
                    * [du_dXn(:,i) du_dYn(:,i) du_dZn(:,i)] * scale_mat * obj.LINE_SCALE;
                dc(i,:) = (obj.p3'*(obj.p4'*u_) - obj.p4'*(obj.p3'*u_))/(obj.p4'*u_)^2 ...
                    * [du_dXn(:,i) du_dYn(:,i) du_dZn(:,i)] * scale_mat * obj.SAMP_SCALE;
            end
        end
    end
end

