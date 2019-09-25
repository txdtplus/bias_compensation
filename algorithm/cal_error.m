function e = cal_error(delta)

m = size(delta,1);
E = 1/m*(delta'*delta);
e = sqrt(sum(diag(E)));
end

