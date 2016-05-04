function [features,featureNames] = calculatePWFeaturesWithoutDic(pw, peaks, valleys)
%% 适配器，让没有降中峡与重博波的信号也能使用特征提取算法
% OUTPUT
% ppgfeatures  长度为21的元胞数组，每个元素都是2列矩阵，其长度参差不齐
% ppgfeaturenames  长度为21的元胞数组，每个元素都是一个ppg波形特征的名字
    dicnotchs = peaks * 0 - 1;
    dicpeaks = dicnotchs;
    
    valleys = [valleys; zeros(length(peaks(:,1)) - length(valleys(:,1)),2)];
    [features, featureNames] = calculatePWFeatures(pw, peaks, valleys, dicnotchs, dicpeaks);
    
    %% 用30是因为第30-35个特征理论上都应为empty但实际却不是，原因尚未可知
    features(30:end) = cell(1,length(features(30:end)));
    featureNames=featureNames(~cellfun(@isempty, features));
    features=features(~cellfun(@isempty, features));
end