function [correlations, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, features, featureNames, needPlot, titleOfSignals)

hrNomal = zeros(size(hr));
hrNomal(:, 1) = hr(:, 1);
hrNomal(:, 2) = (hr(:, 2) - mean(hr(:, 2))) ./ std(hr(:, 2));

if needPlot
    fig = figure('Name', [titleOfSignals, ' - Correlations between feature and HR.'],...
        'Outerpos', get(0, 'ScreenSize'));
else
    fig = 0;
end
len = length(features);
correlations = zeros(len, 1);
[row, col] = getSubplotsSize(len);
for i = 1 : len
    %% ׼������
    feature = features{i};
    name = featureNames{i};
    if length(feature) < 5
        continue;
    end
    
    %% ����1��ȥ���ߣ���һ��
    featureNormal = zeros(size(feature));
    featureNormal(:, 1) = feature(:, 1);
    featureNormal(:, 2) = (feature(:, 2) - mean(feature(:, 2))) ./ std(feature(:, 2));
    
    %% ����2���ҳ���Ӧ��,�����������
    [hrMap, featureMap] = mapSignals(hr, feature);
    correlations(i) = corr(hrMap(:, 2), featureMap(:, 2));
    
    %% ����3����ͼ
    if needPlot
        subplot(row, col, i), 
        plot(featureNormal(:, 1), featureNormal(:, 2), 'b'); hold on,
        plot(featureNormal(:, 1), featureNormal(:, 2), 'b*'); hold on,
        plot(hrNomal(:, 1), hrNomal(:, 2), 'r');
        plot(hrNomal(:, 1), hrNomal(:, 2), 'ro');
        title([name, ' CORR: ', num2str(correlations(i))]);
    end
    
end     %end for 


end