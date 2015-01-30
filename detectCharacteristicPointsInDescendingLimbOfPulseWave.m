function [dicNotches, dicPeaks] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% [percent10s, percent50s] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% 在脉搏波的上升沿中检测关键点：10%，50%
% 输入：
%   data：目标信号
%   onsets：脉搏波起始点
%   peaks：脉搏波波峰
% 输出：
%   percent10s： N x 2   10%点的位置和幅值
%   percent50s： N x 2   50%点的位置和幅值

%% 步骤1：去除漏检的关键点
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1)) * 1.2;
[peaks, onsets] = match2data(peaks, onsets, maxInterval);

%% 步骤2：初始化结果数据
dicNotches = zeros(size(onsets));
dicPeaks = zeros(size(onsets));

%% 步骤3：对每个心动周期检测关键点
for i = 1 : size(onsets, 1)
    descendingEdge = data(peaks(i, 1) : onsets(i, 1));
    [dnIdx, dpIdx] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, 'PEAK');%'DISTANCE'); %
    dnIdx = dnIdx + peaks(i, 1) - 1;
    dpIdx = dpIdx + peaks(i, 1) - 1;
    dicNotches(i, :) = [dnIdx, data(dnIdx)];
    dicPeaks(i, :) = [dpIdx, data(dpIdx)];
end % for 


end