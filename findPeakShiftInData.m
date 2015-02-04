function [ peakpos ] = findPeakShiftInData(data)
%FINDPEAKSHIFTINDATA �����ݶ�data�в���һ����ֵ��λ�ã����û�з��ַ�ֵ���򷵻�-1
%   Ҫ�����ݶ�����һ�����ݵ�ֵ����data����ֵ s-��ʼֵ o-�ҵ��ķ�ֵ e-����ֵ
%                   o
%           *           *
%      *                    **
%   s                               *
%                                           e
%   ����
%   data - [N,1]���� ÿһ�д���һ����
%   ���
%   peakpos - ��ֵ��λ��
%% Ԥ����
peakpos = -1;
%% �ж������Ƿ����Ҫ��
len = length(data);
if len<3
    return
end
%% �����Ƿ��г�����ʼ��yֵ�����ݶ�
pos = find(data > data(1));
if isempty(pos)
    return
end
[~,ppos] = max(data(data>data(1)));
peakpos = pos(ppos);
end

