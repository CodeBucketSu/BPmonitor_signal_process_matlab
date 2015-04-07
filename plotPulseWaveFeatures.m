function [fig] = plotPulseWaveFeatures(features, featureNames, titleOfSignals)
% plotPulseWaveFeatures(features, featureNames) ´òÓ¡Âö²«²¨ÌØÕ÷

fig = figure('Name', [titleOfSignals, ' - features of pulse wave'], ...
    'Position', get(0, 'ScreenSize'));

len = length(features);
[row, col] = getSubplotsSize(len);
for i = 1 : len
    subplot(row, col, i);
    feature = features{i};
    if ~ isempty(feature)
        plot(feature(:, 1), feature(:, 2));
    end
    title(featureNames{i});
end

end