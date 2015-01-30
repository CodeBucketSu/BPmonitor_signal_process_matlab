function [percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks)
% [percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks)
% 在脉搏波的上升沿中检测关键点：10%，50%
% 输入：
%   data：目标信号
%   onsets：脉搏波起始点
%   peaks：脉搏波波峰
% 输出：
%   percent10s： N x 2   10%点的位置和幅值
%   percent50s： N x 2   50%点的位置和幅值

%% 步骤1：去除漏检的关键点
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1))/2;
[onsets, peaks] = match2data(onsets, peaks, maxInterval);

%% 步骤2：初始化结果数据
percent10s = zeros(size(onsets));
percent50s = zeros(size(onsets));

%% 步骤3：对每个心动周期检测关键点
for i = 1 : size(onsets, 1)
    risingEdge = data(onsets(i, 1) : peaks(i, 1));
    p10Idx = detectKpercentKeyPoint(risingEdge, 0.1) + onsets(i, 1) - 1;
    percent10s(i, :) = [p10Idx, data(p10Idx)];
    p50Idx = detectKpercentKeyPoint(risingEdge, 0.5) + onsets(i, 1) - 1;
    percent50s(i, :) = [p50Idx, data(p50Idx)];
end % for 


end