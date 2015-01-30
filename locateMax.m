function [idx] = locateMax(src, firstOrLast)
% [idx] = locateMax(src) 返回最大值出现所在的位置
% src：目标数组
% firstOrLast：两个值：'first', 'last'
idx = find(src == max(src(:)), 1, firstOrLast);

end