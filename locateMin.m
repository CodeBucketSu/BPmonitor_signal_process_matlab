function [idx] = locateMin(src, firstOrLast)
% [idx] = locateMin(src) 返回最大值出现所在的位置
% src：目标数组
% firstOrLast：两个值：'first', 'last'
idx = find(src == min(src(:)), 1, firstOrLast);

end