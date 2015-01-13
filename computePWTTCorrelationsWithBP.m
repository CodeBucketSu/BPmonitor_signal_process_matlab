function [corrBP2PWTT, corrPWTT2HR, corrBP2HR, fig] = computePWTTCorrelationsWithBP(bp, pwtts, pwttNames, hr, corrPwttHrs, titleOfSignals)

bpNomal = (bp - mean(bp)) ./ std(bp);
hrNomal = (hr - mean(hr)) ./ std(hr);

fig = figure('Name', [titleOfSignals, ' - Compute the Correlations between PWTT and BP.'], ...
    'OuterPos', get(0, 'ScreenSize'));
len = size(pwtts, 1);
corrBP2PWTT = zeros(len, 1);
corrBP2HR = zeros(len, 1);
corrPWTT2HR = zeros(len, 1);

for i = 1 : len
    %% ׼������
    pwtt = pwtts(i, :);
    name = pwttNames{i};
    
    %% ����1��ȥ���ߣ���һ��
    pwttNormal = (pwtt - mean(pwtt)) ./ std(pwtt);
    
    %% ����2���ҳ���Ӧ��,�����������
    corrBP2PWTT(i) = corr(bp.', pwtt.');
    corrBP2HR(i) = corr(bp.', hr.');
    corrPWTT2HR(i) = corr(pwtt.', hr.');
    
    %% ����3����ͼ
    subplot(3, 4, i), 
    plot(pwttNormal, 'b'); hold on,
    plot(pwttNormal, 'b*'); hold on,
    plot(bpNomal, 'r');
    plot(bpNomal, 'ro');
    plot(hrNomal, 'g');
    plot(hrNomal, 'go');
    title({['[meanPWTT and BP:', name];...
         ['corrBP2PWTT: ', num2str(corrBP2PWTT(i)), '   meanCorrPWTT2PWTT: ', num2str(corrPwttHrs(i))];...
         ['corrPWTT2HR: ', num2str(corrPWTT2HR(i)), '   corrBP2HR: ', num2str(corrBP2HR(i))];...
    });
    
    
end     %end for 


end