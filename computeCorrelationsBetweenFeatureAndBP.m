function [corrBP2Feature, corrFeature2HR, corrBP2HR, fig] = computeCorrelationsBetweenFeatureAndBP(bp, features, featureNames, hr, corrFeatureHrs, titleOfSignals)

bpNomal = (bp - mean(bp)) ./ std(bp);
hrNomal = (hr - mean(hr)) ./ std(hr);

fig = figure('Name', [titleOfSignals, ' - Compute the Correlations between Feature and BP.'], ...
    'OuterPos', get(0, 'ScreenSize'));
len = size(features, 1);
corrBP2Feature = zeros(len, 1);
corrBP2HR = zeros(len, 1);
corrFeature2HR = zeros(len, 1);


[row, col] = getSubplotsSize(len);

for i = 1 : len
    %% ׼������
    feature = features(i, :);
    name = featureNames{i};
    
    %% ����1��ȥ���ߣ���һ��
    featureNormal = (feature - mean(feature)) ./ std(feature);
    
    %% ����2���ҳ���Ӧ��,�����������
    corrBP2Feature(i) = corr(bp.', feature.');
    corrBP2HR(i) = corr(bp.', hr.');
    corrFeature2HR(i) = corr(feature.', hr.');
    
    %% ����3����ͼ
    subplot(row, col, i), 
    plot(featureNormal, 'b'); hold on,
    plot(featureNormal, 'b*'); hold on,
    plot(bpNomal, 'r');
    plot(bpNomal, 'ro');
    plot(hrNomal, 'g');
    plot(hrNomal, 'go');
    title({['[Feature:', name, '; ', 'Ftr2BP: ', num2str(corrBP2Feature(i))];
         ['BP2HR: ', num2str(corrBP2HR(i)), '; ','Ftr2HR: ', num2str(corrFeature2HR(i))];
         %['meanPWTT2HR: ', num2str(corrFeatureHrs(i))];
    });
    
    
end     %end for 


end
