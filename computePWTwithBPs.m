function [ pwtPeak, pwtValley, pwtKey, pwtRise, fig, hasError ] = computePWTwithBPs( bpStart, bpEnd, ifplot, titleOfSignals )
%COMPUTEPWTWITHbpStartANDRAEND Summary of this function goes here
%   Detailed explanation goes here

%% 步骤1：滤波
bpEnd = sigfilter(bpEnd);
bpStart = sigfilter(bpStart);

%% 步骤2：提取起始端脉搏波关键点
[bpStart_peak, bpStart_valley, bpStart_key, bpStart_rise]= detectPeaksInPulseWave(bpStart);

%% 步骤3：提取终止端脉搏波关键点
[bpEnd_peak, bpEnd_valley, bpEnd_key, bpEnd_rise]= detectPeaksInPulseWave(bpEnd);

%% 步骤4：计算pwt
[pwtPeak, bpStart_peak_used, bpEnd_peak_used]  = compute_pwtt(bpStart_peak, bpEnd_peak, 0, 150);
[pwtValley, bpStart_valley_used, bpEnd_valley_used] = compute_pwtt(bpStart_valley, bpEnd_valley, 0, 150);
[pwtKey, bpStart_key_used, bpEnd_key_used] = compute_pwtt(bpStart_key, bpEnd_key, 0, 150);
[pwtRise, bpStart_rise_used, bpEnd_rise_used] = compute_pwtt(bpStart_rise, bpEnd_rise, 0, 150);

%% 步骤5：验证步骤4是否排除了太多点
isTrue = 0;
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_peak, bpEnd_peak}, {bpStart_peak_used, bpEnd_peak_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_valley,bpEnd_valley}, {bpStart_valley_used, bpEnd_valley_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_key,bpStart_key}, {bpStart_key_used, bpEnd_key_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_rise,bpEnd_rise}, {bpStart_rise_used, bpEnd_rise_used});
hasError = isTrue;

%% 步骤6：根据需要画图
if ifplot || isTrue
    fig = figure('Name', titleOfSignals);
    subplot(311), drawSignalPeaksAndPeaksUsed(bpStart, ...
        {bpStart_peak, bpStart_valley, bpStart_key, bpStart_rise}, ...
        {bpStart_peak_used, bpStart_valley_used, bpStart_key_used, bpStart_rise_used}, ...
        'b');
    subplot(312), drawSignalPeaksAndPeaksUsed(bpEnd, ...
        {bpEnd_peak, bpEnd_valley, bpEnd_key, bpEnd_rise}, ...
        {bpEnd_peak_used, bpEnd_valley_used, bpEnd_key_used, bpEnd_rise_used}, ...
        'r');
    subplot(313), drawPWTTs({pwtPeak, pwtValley, pwtKey, pwtRise}, ...
        {'pwtPeak', 'pwtValley', 'pwtKey', 'pwtRise'});
else
    fig = 0;
end

%% 步骤7：去除异常点
pwtPeak = removeOutlier(pwtPeak, 2, 10);
pwtValley = removeOutlier(pwtValley, 2, 10);
pwtKey = removeOutlier(pwtKey, 2, 10);
pwtRise = removeOutlier(pwtRise, 2, 10);

end

