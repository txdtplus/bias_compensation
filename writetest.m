clear; clc;
load rpc2;
rpc_file = fopen('RPC1.txt');
rpc = textscan(rpc_file,'%s %f32 %s');
fclose(rpc_file);

RPC = cell(1,3);
%% RPC{1} name
RPC{1} = {'LINE_OFF:';'SAMP_OFF:';'LAT_OFF:';'LONG_OFF:';'HEIGHT_OFF';...
    'LINE_SCALE:';'SAMP_SCALE:';'LAT_SCALE:';'LONG_SCALE:';'HEIGHT_SCALE';...   
    'LINE_NUM_COEFF_1:'; 'LINE_NUM_COEFF_2:'; 'LINE_NUM_COEFF_3:'; 'LINE_NUM_COEFF_4:'; 'LINE_NUM_COEFF_5:';...
    'LINE_NUM_COEFF_6:'; 'LINE_NUM_COEFF_7:'; 'LINE_NUM_COEFF_8:'; 'LINE_NUM_COEFF_9:'; 'LINE_NUM_COEFF_10:';...
    'LINE_NUM_COEFF_11:';'LINE_NUM_COEFF_12:';'LINE_NUM_COEFF_13:';'LINE_NUM_COEFF_14:';'LINE_NUM_COEFF_15:';...
    'LINE_NUM_COEFF_16:';'LINE_NUM_COEFF_17:';'LINE_NUM_COEFF_18:';'LINE_NUM_COEFF_19:';'LINE_NUM_COEFF_20:';...   
    'LINE_DEN_COEFF_1:'; 'LINE_DEN_COEFF_2:'; 'LINE_DEN_COEFF_3:'; 'LINE_DEN_COEFF_4:'; 'LINE_DEN_COEFF_5:';...
    'LINE_DEN_COEFF_6:'; 'LINE_DEN_COEFF_7:'; 'LINE_DEN_COEFF_8:'; 'LINE_DEN_COEFF_9:'; 'LINE_DEN_COEFF_10:';...
    'LINE_DEN_COEFF_11:';'LINE_DEN_COEFF_12:';'LINE_DEN_COEFF_13:';'LINE_DEN_COEFF_14:';'LINE_DEN_COEFF_15:';...
    'LINE_DEN_COEFF_16:';'LINE_DEN_COEFF_17:';'LINE_DEN_COEFF_18:';'LINE_DEN_COEFF_19:';'LINE_DEN_COEFF_20:';...
    'SAMP_NUM_COEFF_1:'; 'SAMP_NUM_COEFF_2:'; 'SAMP_NUM_COEFF_3:'; 'SAMP_NUM_COEFF_4:'; 'SAMP_NUM_COEFF_5:';...
    'SAMP_NUM_COEFF_6:'; 'SAMP_NUM_COEFF_7:'; 'SAMP_NUM_COEFF_8:'; 'SAMP_NUM_COEFF_9:'; 'SAMP_NUM_COEFF_10:';...
    'SAMP_NUM_COEFF_11:';'SAMP_NUM_COEFF_12:';'SAMP_NUM_COEFF_13:';'SAMP_NUM_COEFF_14:';'SAMP_NUM_COEFF_15:';...
    'SAMP_NUM_COEFF_16:';'SAMP_NUM_COEFF_17:';'SAMP_NUM_COEFF_18:';'SAMP_NUM_COEFF_19:';'SAMP_NUM_COEFF_20:';...
    'SAMP_DEN_COEFF_1:'; 'SAMP_DEN_COEFF_2:'; 'SAMP_DEN_COEFF_3:'; 'SAMP_DEN_COEFF_4:'; 'SAMP_DEN_COEFF_5:';...
    'SAMP_DEN_COEFF_6:'; 'SAMP_DEN_COEFF_7:'; 'SAMP_DEN_COEFF_8:'; 'SAMP_DEN_COEFF_9:'; 'SAMP_DEN_COEFF_10:';...
    'SAMP_DEN_COEFF_11:';'SAMP_DEN_COEFF_12:';'SAMP_DEN_COEFF_13:';'SAMP_DEN_COEFF_14:';'SAMP_DEN_COEFF_15:';...
    'SAMP_DEN_COEFF_16:';'SAMP_DEN_COEFF_17:';'SAMP_DEN_COEFF_18:';'SAMP_DEN_COEFF_19:';'SAMP_DEN_COEFF_20:'...
    };

%% RPC{2} value
RPC{2} = zeros(90,1);
RPC{2}(1) = rpc2.LINE_OFF;  RPC{2}(2) = rpc2.SAMP_OFF;  
RPC{2}(3) = rpc2.LAT_OFF;   RPC{2}(4) = rpc2.LONG_OFF;  
RPC{2}(5) = rpc2.H_OFF;
RPC{2}(6) = rpc2.LINE_SCALE;  RPC{2}(7) = rpc2.SAMP_SCALE;  
RPC{2}(8) = rpc2.LAT_SCALE;   RPC{2}(9) = rpc2.LONG_SCALE;  
RPC{2}(10) = rpc2.H_SCALE;
RPC{2}(11:30) = rpc2.p1;    RPC{2}(31:50) = rpc2.p2;
RPC{2}(51:70) = rpc2.p3;    RPC{2}(71:90) = rpc2.p4;
% RPC{2} = single(RPC{2});

%% RPC{3} dimension
RPC{3} = cell(90,1);
RPC{3}{1} = 'pixels';   RPC{3}{2} = 'pixels';
RPC{3}{3} = 'degrees';   RPC{3}{4} = 'degrees';
RPC{3}{5} = 'meters';   RPC{3}{6} = 'pixels';
RPC{3}{7} = 'pixels';   RPC{3}{8} = 'degrees';
RPC{3}{9} = 'degrees';   RPC{3}{10} = 'meters';

%% write RPC
rpc_out_file = fopen('new_RPC.txt','w');
for i = 1:90   
    fprintf(rpc_out_file,'%s ',RPC{1}{i}); 
    if i > 10
        if RPC{2}(i) > 0
            fprintf(rpc_out_file,'+%.15E ',RPC{2}(i)); 
        else
            fprintf(rpc_out_file,'%.15E ',RPC{2}(i)); 
        end
    else
        if RPC{2}(i) > 0
            fprintf(rpc_out_file,'+%.8E ',RPC{2}(i)); 
        else
            fprintf(rpc_out_file,'%.8E ',RPC{2}(i)); 
        end
    end
    fprintf(rpc_out_file,'%s\n',RPC{3}{i});
end
fclose(rpc_out_file);



