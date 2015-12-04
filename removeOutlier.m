function [ ret, idx ] = removeOutlier( data, colNum, win)
%REMOVEOUTLIER 去除置信区间外的数据点
%  INPUT
%	data	原始数据
%	colNum	数据列数
%	win		没有用到
%  OUTPUT
%	ret 	置信区间内的数据
%	idx		置信区间内数据在原始数据中的位置 

%% 求标准差
origin = data(:, colNum);
var = std(origin);

noBase = baseLineFilter(origin, 10);
idx = abs(noBase) < (var * 3);

ret = data(idx, :);

end

