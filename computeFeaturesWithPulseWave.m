function [features, featureNames]  = computeFeaturesWithPulseWave(pw)
% computeFeaturesWithPulseWave(pw, ifplot, titleOfSignals) 从单个脉搏波中提取特征

%% 步骤1：滤波
pw = sigfilter(pw);

%% 步骤2：提取关键点
[peaks, valleys, ~, ~, dicNotchs, dicPeaks]= detectPeaksInPulseWave(pw);

%% 步骤3：计算特征
[features, featureNames] = calculatePWFeatures(pw, peaks, valleys, dicNotchs, dicPeaks);

end