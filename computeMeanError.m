function ME = computeMeanError(real, est)
% ME = computeMeanError(real, est) ����������ֵ��ƽ��ֵ
% real����ʵֵ
% est������ֵ

error = real - est;
error = abs(error);
ME = mean(error);

end