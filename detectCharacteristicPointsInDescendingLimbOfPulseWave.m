function [dicNotches, dicPeaks] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% [percent10s, percent50s] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% �����������������м��ؼ��㣺10%��50%
% ���룺
%   data��Ŀ���ź�
%   onsets����������ʼ��
%   peaks������������
% �����
%   percent10s�� N x 2   10%���λ�úͷ�ֵ
%   percent50s�� N x 2   50%���λ�úͷ�ֵ

%% ����1��ȥ��©��Ĺؼ���
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1)) * 1.2;
[peaks, onsets] = match2data(peaks, onsets, maxInterval);

%% ����2����ʼ���������
dicNotches = zeros(size(onsets));
dicPeaks = zeros(size(onsets));

%% ����3����ÿ���Ķ����ڼ��ؼ���
for i = 1 : size(onsets, 1)
    descendingEdge = data(peaks(i, 1) : onsets(i, 1));
    [dnIdx, dpIdx] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, 'PEAK');%'DISTANCE'); %
    dnIdx = dnIdx + peaks(i, 1) - 1;
    dpIdx = dpIdx + peaks(i, 1) - 1;
    dicNotches(i, :) = [dnIdx, data(dnIdx)];
    dicPeaks(i, :) = [dpIdx, data(dpIdx)];
end % for 


end