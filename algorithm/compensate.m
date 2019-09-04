function after_compen_loc = compensate(A,coff,cal_loc)

L_ = A*coff;
compen_loc = zeros(size(cal_loc));
compen_loc(:,1) = L_(1:2:end-1);
compen_loc(:,2) = L_(2:2:end);
after_compen_loc = cal_loc + compen_loc;
end

