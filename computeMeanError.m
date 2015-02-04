function ME = computeMeanError(real, est)
% ME = computeMeanError(real, est) 计算误差绝对值的平均值
% real：真实值
% est：估计值

error = real - est;
error = abs(error);
ME = mean(error);

end