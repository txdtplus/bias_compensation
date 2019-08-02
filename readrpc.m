function [DRPC,IRPC,Normalize_par] = readrpc(file_imput)
% r = P2/P1: 图像行数  c = P4/P3: 图像列数
% DRPC: 四列，分别是 P1 P2 P3 P4。 IRPC是反向RPC，表达相同
% Normalize_par 五列, 用于归一化
% LONG_n,LAT_n,H_n,r_n,c_n 分别是两行列向量。第一个是scale, 第二个是off
xml_rpc1 = parseXML(file_imput);

rfm = xml_rpc1.Children(4);
Global_rfm = rfm.Children(4);
Direct_model = Global_rfm.Children(2);
Inverse_model = Global_rfm.Children(4);
RFM_validity = Global_rfm.Children(6);

d_c_den = zeros(20,1);
d_c_num = zeros(20,1);
d_r_den = zeros(20,1);
d_r_num = zeros(20,1);
i_c_den = zeros(20,1);
i_c_num = zeros(20,1);
i_r_den = zeros(20,1);
i_r_num = zeros(20,1);

for i = 1:20
    d_c_den(i) = str2double(Direct_model.Children(2*i).Children.Data);
    d_c_num(i) = str2double(Direct_model.Children(2*i+40).Children.Data);
    d_r_den(i) = str2double(Direct_model.Children(2*i+80).Children.Data);
    d_r_num(i) = str2double(Direct_model.Children(2*i+120).Children.Data);    
end

for i = 1:20
    i_c_den(i) = str2double(Inverse_model.Children(2*i).Children.Data);
    i_c_num(i) = str2double(Inverse_model.Children(2*i+40).Children.Data);
    i_r_den(i) = str2double(Inverse_model.Children(2*i+80).Children.Data);
    i_r_num(i) = str2double(Inverse_model.Children(2*i+120).Children.Data);   
end

LONG_SCALE = str2double(RFM_validity.Children(6).Children.Data);
LONG_OFF = str2double(RFM_validity.Children(8).Children.Data);
LAT_SCALE = str2double(RFM_validity.Children(10).Children.Data);
LAT_OFF = str2double(RFM_validity.Children(12).Children.Data);
HEIGHT_SCALE = str2double(RFM_validity.Children(14).Children.Data);
HEIGHT_OFF = str2double(RFM_validity.Children(16).Children.Data);

SAMP_SCALE = str2double(RFM_validity.Children(18).Children.Data);
SAMP_OFF = str2double(RFM_validity.Children(20).Children.Data);
LINE_SCALE = str2double(RFM_validity.Children(22).Children.Data);
LINE_OFF = str2double(RFM_validity.Children(24).Children.Data);

DRPC = [d_r_num, d_r_den, d_c_num, d_c_den];
IRPC = [i_r_num, i_r_den, i_c_num, i_c_den];

LONG_n = [LONG_SCALE;LONG_OFF];
LAT_n = [LAT_SCALE;LAT_OFF];
H_n = [HEIGHT_SCALE;HEIGHT_OFF];

r_n = [LINE_SCALE;LINE_OFF];
c_n = [SAMP_SCALE;SAMP_OFF];

Normalize_par = [LONG_n,LAT_n,H_n,r_n,c_n];

end

