function [area] = calcArea(vals)
% 计算vals曲线段下的面积
% vals 曲线段 - 已减去最小值

area = sum(vals) - (vals(1) + vals(end))*length(vals)/2;