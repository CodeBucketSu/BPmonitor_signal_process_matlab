function [area] = calcArea(vals)
% ����vals���߶��µ����
% vals ���߶� - �Ѽ�ȥ��Сֵ

if length(vals(:,1)) == 0
	area = 0;
	return;
end
area = sum(vals) - (vals(1) + vals(end))*length(vals)/2;