function [area] = calcArea(vals)
% ����vals���߶��µ����
% vals ���߶� - �Ѽ�ȥ��Сֵ

area = sum(vals) - (vals(1) + vals(end))*length(vals)/2;