function [fig] = plotPulseWaveFeatures(features, featureNames, titleOfSignals)
% plotPulseWaveFeatures(features, featureNames) ��ӡ����������

fig = figure('Name', [titleOfSignals, ' - features of pulse wave'], ...
    'OuterPos', get(0, 'ScreenSize'));

len = length(features);
for i = 1 : len
    subplot(5, 6, i);
    feature = features{i};
    if ~ isempty(feature)
        plot(feature(:, 1), feature(:, 2));
    end
    title(featureNames{i});
end

end