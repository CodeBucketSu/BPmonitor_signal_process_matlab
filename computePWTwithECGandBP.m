function [ pwtPeak, pwtValley, pwtKey, pwtRise, hr, fig, hasError ] = computePWTwithECGandBP( ecg, bp, ifplot, titleOfSignals )
%COMPUTEPWTWITHECGANDRAEND Summary of this function goes here
%   Detailed explanation goes here


%% ����1���˲�
% bp = sigfilter(bp);
% ecg = sigfilter(ecg);

%% ����2�����R�����壬��������
[ecg_peak, hr]=HR_detection(ecg);

%% ����3����ȡ�������ؼ���
[bp_peak, bp_valley, bp_key, bp_rise]= detectPeaksInPulseWave(bp);
% tmpStruct = load('tmpdata.mat');
% bp_peak = tmpStruct.peaks;
% bp_valley = tmpStruct.onsets;
% bp_key = tmpStructent10s;
% bp_rise = tmpStruct.percent50s;

%% ����4������pwt,����֤�Ƿ��ų���̫���
[pwtPeak, ~, bp_peak_used] = computeTimeInterval(ecg_peak, bp_peak, floor(getSampleRate(1) / 1000 * 100), floor(getSampleRate(1) / 1000 * 400));
[pwtValley, ~, bp_valley_used] = computeTimeInterval(ecg_peak, bp_valley, floor(getSampleRate(1) / 1000 * 50), floor(getSampleRate(1) / 1000 * 400));
[pwtKey, ecg_peak_used, bp_key_used] = computeTimeInterval(ecg_peak, bp_key, floor(getSampleRate(1) / 1000 * 50), floor(getSampleRate(1) / 1000 * 400));
[pwtRise, bp_valley_used1, bp_peak_used1] = computeTimeInterval(bp_valley, bp_peak, 10, floor(getSampleRate(1) / 1000 * 200));


%% ����5����֤����4�Ƿ��ų���̫���
isTrue = 1;
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, bp_peak}, {ecg_peak_used, bp_peak_used});
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, pwtValley}, {ecg_peak_used, bp_valley_used});
isTrue = isTrue || isTooManyPeaksRemoved({ecg_peak, bp_key}, {ecg_peak_used, bp_key_used});
isTrue = isTrue || isTooManyPeaksRemoved({bp_valley, bp_peak}, {bp_valley_used1, bp_peak_used1});
hasError = isTrue;

%% ����6��������Ҫ��ͼ
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

%% ����7��ȥ��ͳ���쳣��
pwtPeak = removeOutlier(pwtPeak, 2, 10);
pwtValley = removeOutlier(pwtValley, 2, 10);
% pwtKey = removeOutlier(pwtKey, 2, 10);
pwtRise = removeOutlier(pwtRise, 2, 10);



end

