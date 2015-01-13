function [correlations, fig] = computePWTTCorrelationsWithHR(hr, pwtts, pwttNames, needPlot, titleOfSignals)

hrNomal = zeros(size(hr));
hrNomal(:, 1) = hr(:, 1);
hrNomal(:, 2) = (hr(:, 2) - mean(hr(:, 2))) ./ std(hr(:, 2));

if needPlot
    fig = figure('Name', [titleOfSignals, ' - Correlations between PWTT and HR.'],...
        'Outerpos', get(0, 'ScreenSize'));
else
    fig = 0;
end
len = length(pwtts);
correlations = zeros(len, 1);
for i = 1 : len
    %% ׼������
    pwtt = pwtts{i};
    name = pwttNames{i};
    if length(pwtt) < 5
        continue;
    end
    
    %% ����1��ȥ���ߣ���һ��
    pwttNormal = zeros(size(pwtt));
    pwttNormal(:, 1) = pwtt(:, 1);
    pwttNormal(:, 2) = (pwtt(:, 2) - mean(pwtt(:, 2))) ./ std(pwtt(:, 2));
    
    %% ����2���ҳ���Ӧ��,�����������
    [hrMap, pwttMap] = mapSignals(hr, pwtt);
    correlations(i) = corr(hrMap(:, 2), pwttMap(:, 2));
    
    %% ����3����ͼ
    if needPlot
        subplot(3, 4, i), 
        plot(pwttNormal(:, 1), pwttNormal(:, 2), 'b'); hold on,
        plot(pwttNormal(:, 1), pwttNormal(:, 2), 'b*'); hold on,
        plot(hrNomal(:, 1), hrNomal(:, 2), 'r');
        plot(hrNomal(:, 1), hrNomal(:, 2), 'ro');
        title([name, ' CORR: ', num2str(correlations(i))]);
    end
    
end     %end for 


end