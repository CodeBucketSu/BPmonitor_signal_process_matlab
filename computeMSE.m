function [MSE] = computeMSE(measuredBPs, estimatedBPs)
% [MSE] = computeError(measuredBPs, estimatedBPs) 计算估计血压和测量血压的均方误差
% MSE = sqrt((E1^2 + E2^2 + ... + En^2)/n)

error = measuredBPs - estimatedBPs;

MSE = sqrt(mean(sum(error.^2)));

end