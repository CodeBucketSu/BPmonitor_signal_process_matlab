function [features, featureNames]  = computeFeaturesWithPulseWave(pw)
% computeFeaturesWithPulseWave(pw, ifplot, titleOfSignals) �ӵ�������������ȡ����

%% ����1���˲�
pw = sigfilter(pw);

%% ����2����ȡ�ؼ���
[peaks, valleys, ~, ~, dicNotchs, dicPeaks]= detectPeaksInPulseWave(pw);

%% ����3����������
[features, featureNames] = calculatePWFeatures(pw, peaks, valleys, dicNotchs, dicPeaks);

end