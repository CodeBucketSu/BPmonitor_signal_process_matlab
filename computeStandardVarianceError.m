function VE = computeStandardVarianceError(real, est)
% ME = computeMeanError(real, est) ����������ֵ�ķ���
% real����ʵֵ
% est������ֵ

error = real - est;
error = abs(error);
VE = std(error);

end