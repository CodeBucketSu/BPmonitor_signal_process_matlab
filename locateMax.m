function [idx] = locateMax(src, firstOrLast)
% [idx] = locateMax(src) �������ֵ�������ڵ�λ��
% src��Ŀ������
% firstOrLast������ֵ��'first', 'last'
idx = find(src == max(src(:)), 1, firstOrLast);

end