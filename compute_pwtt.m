function [PWTT, peakStartUsed, peakEndUsed] = compute_pwtt(peakStart, peakEnd, minPWTT, maxPWTT)

%% ����1��Ѱ�Ҷ�Ӧ��
[peakStartUsed, peakEndUsed] = mapSignals(peakStart, peakEnd);
PWTT = peakStartUsed;
PWTT(:, 2) = peakEndUsed(:, 1) - peakStartUsed(:, 1);
% figure, plot(PWTT(:, 1), PWTT(:, 2));

%% ����2��ȥ����ֵ����Ҫ��ĵ�
idx = find((PWTT(:, 2) > minPWTT) .* (PWTT(:, 2) < maxPWTT));
peakStartUsed = peakStartUsed(idx, :);
peakEndUsed = peakEndUsed(idx, :);
PWTT = PWTT(idx, :);
% hold on, plot(PWTT(:, 1), PWTT(:, 2), 'r');

%% ����3��ȥ���쳣��
[ PWTT, idx ] = removeOutlier( PWTT, 2, 10 );
peakStartUsed = peakStartUsed(idx, :);
peakEndUsed = peakEndUsed(idx, :);
% hold on, plot(PWTT(:, 1), PWTT(:, 2), 'g');


end
