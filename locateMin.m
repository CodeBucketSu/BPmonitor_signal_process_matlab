function [idx] = locateMin(src, firstOrLast)
% [idx] = locateMin(src) �������ֵ�������ڵ�λ��
% src��Ŀ������
% firstOrLast������ֵ��'first', 'last'
idx = find(src == min(src(:)), 1, firstOrLast);

end