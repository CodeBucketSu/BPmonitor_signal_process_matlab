function VE = computeStandardVarianceError(real, est)
% ME = computeMeanError(real, est) 计算误差绝对值的方差
% real：真实值
% est：估计值

error = real - est;
error = abs(error);
VE = std(error);

end