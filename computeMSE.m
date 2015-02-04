function [MSE] = computeMSE(measuredBPs, estimatedBPs)
% [MSE] = computeError(measuredBPs, estimatedBPs) �������Ѫѹ�Ͳ���Ѫѹ�ľ������
% MSE = sqrt((E1^2 + E2^2 + ... + En^2)/n)

error = measuredBPs - estimatedBPs;

MSE = sqrt(mean(sum(error.^2)));

end