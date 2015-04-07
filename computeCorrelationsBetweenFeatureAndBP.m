function [corrBP2Feature, corrFeature2HR, corrBP2HR, fig] = computeCorrelationsBetweenFeatureAndBP(bp, features, featureNames, hr, corrFeatureHrs, titleOfSignals)

bpNomal = (bp - mean(bp)) ./ std(bp);
hrNomal = (hr - mean(hr)) ./ std(hr);

fig = figure('Name', [titleOfSignals, ' - Compute the Correlations between Feature and BP.'], ...
    'Position', get(0, 'ScreenSize'));
len = length(featureNames(:));%����featuresΪ�յ��µ�����
corrBP2Feature = zeros(len, 2);
corrBP2HR = zeros(len, 2);
corrFeature2HR = zeros(len, 2);
bp1 = bp;
hr1 = hr;
[row, col] = getSubplotsSize(len);
if isempty(features) || isempty(bp) || isempty(hr)
    len = 0;
end

for i = 1 : len
    %% ׼������
    feature = features(i, :);
    idxNotNaN = ~isnan(feature);
    feature = feature(idxNotNaN);
    bp = bp1(idxNotNaN);
    hr = hr1(idxNotNaN);
    name = featureNames{i};
    
    %% ����1��ȥ���ߣ���һ��
    featureNormal = (feature - mean(feature)) ./ std(feature);
    
    %% ����2���ҳ���Ӧ��,�����������
    [corrBP2Feature(i, 1), corrBP2Feature(i, 2)] = corr(bp.', feature.');
    [corrBP2HR(i, 1), corrBP2HR(i, 2)] = corr(bp.', hr.');
    [corrFeature2HR(i, 1), corrFeature2HR(i, 2)] = corr(feature.', hr.');
    
    %% ����3����ͼ
    subplot(row, col, i), 
    plot(featureNormal, 'b'); hold on,
    plot(featureNormal, 'b*'); hold on,
    plot(bpNomal, 'r');
    plot(bpNomal, 'ro');
    plot(hrNomal, 'g');
    plot(hrNomal, 'go');
    title({[name, ': ', 'Ftr2BP: ', num2str(corrBP2Feature(i, 1), 3), ', ', num2str(corrBP2Feature(i, 2), 3)];
         ['Ftr2HR: ', num2str(corrFeature2HR(i), 3), ', ', num2str(corrFeature2HR(i, 2), 3)];
         %'BP2HR: ', num2str(corrBP2HR(i), 3), '; ',
         %['meanPWTT2HR: ', num2str(corrFeatureHrs(i))];
    });
    
    
end     %end for 


end
