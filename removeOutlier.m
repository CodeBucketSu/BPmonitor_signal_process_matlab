function [ ret, idx ] = removeOutlier( data, colNum, win )
%REMOVEOUTLIER Summary of this function goes here
%   Detailed explanation goes here

%% Çó±ê×¼²î
origin = data(:, colNum);
var = std(origin);

noBase = baseLineFilter(origin, 10);
idx = abs(noBase) < (var * 3);

ret = data(idx, :);

end

