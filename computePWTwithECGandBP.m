function [ pwtPeak, pwtValley, pwtKey, pwtRise, hr, fig, hasError ] = computePWTwithECGandBP( ecg, bp, ifplot, titleOfSignals )
%COMPUTEPWTWITHECGANDRAEND Summary of this function goes here
%   Detailed explanation goes here


%% 步骤1：滤波
% bp = sigfilter(bp);
% ecg = sigfilter(ecg);

%% 步骤2：检测R波波峰，计算心率
[ecg_peak, hr]=HR_detection(ecg);

%% 步骤3：提取脉搏波关键点
[bp_peak, bp_valley, bp_key, bp_rise]= detectPeaksInPulseWave(bp);
% tmpStruct = load('tmpdata.mat');
% bp_peak = tmpStruct.peaks;
% bp_valley = tmpStruct.onsets;
% bp_key = tmpStructent10s;
% bp_rise = tmpStruct.percent50s;

%% 步骤4：计算pwt,并验证是否排除了太多点
[pwtPeak, ~, bp_peak_used] = computeTimeInterval(ecg_peak, bp_peak, floor(getSampleRate(1) / 1000 * 100), floor(getSampleRate(1) / 1000 * 400));
[pwtValley, ~, bp_valley_used] = computeTimeInterval(ecg_peak, bp_valley, floor(getSampleRate(1) / 1000 * 50), floor(getSampleRate(1) / 1000 * 400));
[pwtKey, ecg_peak_used, bp_key_used] = computeTimeInterval(ecg_peak, bp_key, floor(getSampleRate(1) / 1000 * 50), floor(getSampleRate(1) / 1000 * 400));
[pwtRise, bp_valley_used1, bp_peak_used1] = computeTimeInterval(bp_valley, bp_peak, 10, floor(getSampleRate(1) / 1000 * 200));


%% 步骤5：验证步骤4是否排除了太多点
isTrue = 1;
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, bp_peak}, {ecg_peak_used, bp_peak_used});
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, pwtValley}, {ecg_peak_used, bp_valley_used});
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, bp_key}, {ecg_peak_used, bp_key_used});
isTrue = isTrue || isTooManyPeaksRemoved({bp_valley, bp_peak}, {bp_valley_used1, bp_peak_used1});
hasError = isTrue;

%% 步骤6：根据需要画图
if ifplot || hasError
    fig = figure('Name', titleOfSignals);
    subplot(311), drawSignalPeaksAndPeaksUsed(ecg, {ecg_peak}, {ecg_peak_used}, 'r');
    subplot(312), drawSignalPeaksAndPeaksUsed(bp, {bp_peak, bp_valley, bp_key}, ...
        {bp_peak_used, bp_valley_used, bp_key_used}, 'b');
    subplot(313), drawPWTTs({pwtPeak, pwtValley, pwtKey, pwtRise}, ...
        {'pwtPeak', 'pwtValley', 'pwtKey', 'PRT'});
else
    fig = [];
end

%% 步骤7：去除统计异常点
pwtPeak = removeOutlier(pwtPeak, 2, 10);
pwtValley = removeOutlier(pwtValley, 2, 10);
% pwtKey = removeOutlier(pwtKey, 2, 10);
pwtRise = removeOutlier(pwtRise, 2, 10);



end

