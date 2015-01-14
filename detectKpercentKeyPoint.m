function [idx] = detectKpercentKeyPoint(risingEdge, percent)
% [idx] = detectKpercentKeyPoint(data, K) ���������ж�λ��ֵ�ٷֵ�
% idx��λ��
% risingEdge�����������ݣ�ͷ����Сֵ��β�����ֵ
% percent���ٷֱ�
keyVal = risingEdge(1) + percent * (risingEdge(end) - risingEdge(1));
delta4key = abs(risingEdge - keyVal);
idx = find(delta4key == min(delta4key), 1,  'first');

end