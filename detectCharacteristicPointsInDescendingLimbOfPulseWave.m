function [dicNotches, dicPeaks] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks,method)
% [percent10s, percent50s] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% �����������������м��ؼ��㣺10%��50%
% ���룺
%   data��Ŀ���ź�
%   onsets����������ʼ��
%   peaks������������
%   method: "WAVELET" - ʹ��С���� "DISTANCE"��"PEAK",etc. - ʹ�þ��뷨
% �����
%   percent10s�� N x 2   10%���λ�úͷ�ֵ
%   percent50s�� N x 2   50%���λ�úͷ�ֵ

%% ����1��ȥ��©��Ĺؼ���
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1)) * 1.2;
[peaks, onsets] = match2data(peaks, onsets, maxInterval);

%% ����2��С����ʹ�õĲ�����״̬����Ԥ����
confactor = 3;%������������
numOfZeroPassPoints = zeros(1,length(onsets(:,1)));%��ÿ���Ĳ����ڴ��һ��������С���任���������
range = [200,0,0];%�þ��뷨����ز���ʱ����Ȩ���г�ʼֵ

%% ����3����ʼ���������
dicNotches = zeros(size(onsets));
dicPeaks = zeros(size(onsets));

%% ����4����ÿ���Ķ����ڼ��ؼ���
for i = 1 : size(onsets, 1)
    descendingEdge = data(peaks(i, 1) : onsets(i, 1));
    if nargin == 4 && strcmp(method,'WAVELET') == 1
        [dnIdx,dpIdx,numOfZeroPassPoints(i)]=detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdge,range(1) );
        % ˥���������µ�range���� - �涨range��ÿ��ֵ�������100
        range = seqShifter(range,dpIdx - dnIdx + 100,i);
    else
        [dnIdx, dpIdx] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, 'PEAK');%'DISTANCE'); %
    end
    % �ж��Ƿ�����ȷ���ز����뽵��Ͽ
    if dnIdx~=-1 && dpIdx~=-1
        dnIdx = dnIdx + peaks(i, 1) - 1;
        dpIdx = dpIdx + peaks(i, 1) - 1;
        dicNotches(i, :) = [dnIdx, data(dnIdx)];
        dicPeaks(i, :) = [dpIdx, data(dpIdx)];
    else
        dicNotches(i,1) = -1;
        dicPeaks(i,1) = -1;
    end
end % for 

%% ����5�������ǰ���õ���С����������ݰ벨���������������ɸѡ��Ч�Ľ���Ͽ���ز���λ��
if nargin == 4 && strcmp(method,'WAVELET') == 1
    numOfZeroPassPoints = numOfZeroPassPoints - mean(numOfZeroPassPoints);
    var = std(numOfZeroPassPoints);
    excludePos = abs(numOfZeroPassPoints) > confactor*var;
    dicNotches(excludePos,:) = ones(sum(double(excludePos)),1)*[-1,0];
    dicPeaks(excludePos,:) = dicNotches(excludePos,:);
end

end