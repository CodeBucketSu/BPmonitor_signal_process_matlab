function [ pwtPeak, pwtValley, pwtKey, pwtRise, fig, hasError ] = computePWTwithBPs( bpStart, bpEnd, ifplot, titleOfSignals )
%COMPUTEPWTWITHbpStartANDRAEND Summary of this function goes here
%   Detailed explanation goes here

%% ����1���˲�
bpEnd = sigfilter(bpEnd);
bpStart = sigfilter(bpStart);

%% ����2����ȡ��ʼ���������ؼ���
[bpStart_peak, bpStart_valley, bpStart_key, bpStart_rise, bpStart_dicnotch, bpStart_dicpeak]= detectPeaksInPulseWave(bpStart);

%% ����3����ȡ��ֹ���������ؼ���
[bpEnd_peak, bpEnd_valley, bpEnd_key, bpEnd_rise, bpEnd_dicnotch, bpEnd_dicpeak]= detectPeaksInPulseWave(bpEnd);

%% ����4������pwt
[pwtPeak, bpStart_peak_used, bpEnd_peak_used]  = computeTimeInterval(bpStart_peak, bpEnd_peak, 0, 150);
[pwtValley, bpStart_valley_used, bpEnd_valley_used] = computeTimeInterval(bpStart_valley, bpEnd_valley, 0, 150);
[pwtKey, bpStart_key_used, bpEnd_key_used] = computeTimeInterval(bpStart_key, bpEnd_key, 0, 150);
[pwtRise, bpStart_rise_used, bpEnd_rise_used] = computeTimeInterval(bpStart_rise, bpEnd_rise, 0, 150);

%% ����5����֤����4�Ƿ��ų���̫���
isTrue = 0;
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_peak, bpEnd_peak}, {bpStart_peak_used, bpEnd_peak_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_valley,bpEnd_valley}, {bpStart_valley_used, bpEnd_valley_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_key,bpStart_key}, {bpStart_key_used, bpEnd_key_used});
isTrue = isTrue || isTooManyPeaksRemoved({bpStart_rise,bpEnd_rise}, {bpStart_rise_used, bpEnd_rise_used});
hasError = isTrue;

%% ����6��������Ҫ��ͼ
if ifplot || isTrue
    fig = figure('Name', titleOfSignals);
    subplot(311), drawSignalPeaksAndPeaksUsed(bpStart, ...
        {bpStart_peak, bpStart_valley, bpStart_key, bpStart_rise, bpStart_dicnotch, bpStart_dicpeak}, ...
        {bpStart_peak_used, bpStart_valley_used, bpStart_key_used, bpStart_rise_used}, ...
        'b');
    subplot(312), drawSignalPeaksAndPeaksUsed(bpEnd, ...
        {bpEnd_peak, bpEnd_valley, bpEnd_key, bpEnd_rise, bpEnd_dicnotch, bpEnd_dicpeak}, ...
        {bpEnd_peak_used, bpEnd_valley_used, bpEnd_key_used, bpEnd_rise_used}, ...
        'r');
    subplot(313), drawPWTTs({pwtPeak, pwtValley, pwtKey, pwtRise}, ...
        {'pwtPeak', 'pwtValley', 'pwtKey', 'pwtRise'});
else
    fig = [];
end


% %��90%���Ϊ90%+10%��ĺͣ��ټ��������
% [pwtRise,pwtKey] = mapSignals(pwtRise,pwtKey);
% pwtRise = pwtRise + pwtKey;
    
%% ����7��ȥ���쳣��
pwtPeak = removeOutlier(pwtPeak, 2, 10);
pwtValley = removeOutlier(pwtValley, 2, 10);
pwtKey = removeOutlier(pwtKey, 2, 10);
pwtRise = removeOutlier(pwtRise, 2, 10);

end

