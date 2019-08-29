classdef GCPs < handle
    %points coordinates
    %
    
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
        
        RPC
    end
    
    methods
        function obj = GCPs(geoloc,DRPC,Normalize_par)
            %UNTITLED3 构造此类的实例
            %   RPC is an RPC object
            obj.X =  geoloc(:,1);
            obj.Y = geoloc(:,2);
            obj.Z = geoloc(:,3);
            
            RPC_ = RPC(DRPC,Normalize_par);
            
            obj.Xn = (obj.X-RPC_.LONG_OFF)/RPC_.LONG_SCALE;
            obj.Yn = (obj.Y-RPC_.LAT_OFF)/RPC_.LAT_SCALE;
            obj.Zn = (obj.Z-RPC_.H_OFF)/RPC_.H_SCALE;
            
            [obj.r,obj.c] = RPC_.obj2img(geoloc);

            obj.rn = (obj.r-RPC_.LINE_OFF)/RPC_.LINE_SCALE;
            obj.cn = (obj.c-RPC_.SAMP_OFF)/RPC_.SAMP_SCALE;
        end
    end
end

