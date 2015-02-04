function [dicNotches, dicPeaks] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks,method)
% [percent10s, percent50s] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks)
% 在脉搏波的上升沿中检测关键点：10%，50%
% 输入：
%   data：目标信号
%   onsets：脉搏波起始点
%   peaks：脉搏波波峰
%   method: "WAVELET" - 使用小波法 "DISTANCE"或"PEAK",etc. - 使用距离法
% 输出：
%   percent10s： N x 2   10%点的位置和幅值
%   percent50s： N x 2   50%点的位置和幅值

%% 步骤1：去除漏检的关键点
maxInterval = median(peaks(2:end, 1) - peaks(1:end-1, 1)) * 1.2;
[peaks, onsets] = match2data(peaks, onsets, maxInterval);

%% 步骤2：小波法使用的参数与状态变量预定义
confactor = 3;%置信区间因子
numOfZeroPassPoints = zeros(1,length(onsets(:,1)));%对每个心搏周期存放一个半周期小波变换过零点数量
range = [200,0,0];%用距离法检测重博波时，加权序列初始值

%% 步骤3：初始化结果数据
dicNotches = zeros(size(onsets));
dicPeaks = zeros(size(onsets));

%% 步骤4：对每个心动周期检测关键点
for i = 1 : size(onsets, 1)
    descendingEdge = data(peaks(i, 1) : onsets(i, 1));
    if nargin == 4 && strcmp(method,'WAVELET') == 1
        [dnIdx,dpIdx,numOfZeroPassPoints(i)]=detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdge,range(1) );
        % 衰减法计算新的range序列 - 规定range的每个值必须大于100
        range = seqShifter(range,dpIdx - dnIdx + 100,i);
    else
        [dnIdx, dpIdx] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, 'PEAK');%'DISTANCE'); %
    end
    % 判断是否检出正确的重搏波与降中峡
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

%% 步骤5：如果当前采用的是小波法，则根据半波长过零点置信区间筛选有效的降中峡与重搏波位置
if nargin == 4 && strcmp(method,'WAVELET') == 1
    numOfZeroPassPoints = numOfZeroPassPoints - mean(numOfZeroPassPoints);
    var = std(numOfZeroPassPoints);
    excludePos = abs(numOfZeroPassPoints) > confactor*var;
    dicNotches(excludePos,:) = ones(sum(double(excludePos)),1)*[-1,0];
    dicPeaks(excludePos,:) = dicNotches(excludePos,:);
end

end