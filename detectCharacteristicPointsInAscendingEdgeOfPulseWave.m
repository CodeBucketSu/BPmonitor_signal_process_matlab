function [percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks)
% [percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks)
% �����������������м��ؼ��㣺10%��50%
% ���룺
%   data��Ŀ���ź�
%   onsets����������ʼ��
%   peaks������������
% �����
%   percent10s�� N x 2   10%���λ�úͷ�ֵ -> 60%
%   percent50s�� N x 2   50%���λ�úͷ�ֵ -> 70%
 
%% ����1��ȥ��©��Ĺؼ���
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1))/2;
[onsets, peaks] = match2data(onsets, peaks, maxInterval);

%% ����2����ʼ���������
percent10s = zeros(size(onsets));
percent50s = zeros(size(onsets));

%% ����3����ÿ���Ķ����ڼ��ؼ���
for i = 1 : size(onsets, 1)
    risingEdge = data(onsets(i, 1) : peaks(i, 1));
    p10Idx = detectKpercentKeyPoint(risingEdge, 0.1) + onsets(i, 1) - 1; % 0.1-> 0.6->0.8
    percent10s(i, :) = [p10Idx, data(p10Idx)];
    p50Idx = detectKpercentKeyPoint(risingEdge, 0.5) + onsets(i, 1) - 1; % 0.5-> 0.7->0.9
    percent50s(i, :) = [p50Idx, data(p50Idx)];
end % for 


end