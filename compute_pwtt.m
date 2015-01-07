function [PWTT, peakStartUsed, peakEndUsed] = compute_pwtt(peakStart, peakEnd, minPWTT, maxPWTT)

%% 步骤1：寻找对应点
[peakStartUsed, peakEndUsed] = mapSignals(peakStart, peakEnd);
PWTT = peakStartUsed;
PWTT(:, 2) = peakEndUsed(:, 1) - peakStartUsed(:, 1);
% figure, plot(PWTT(:, 1), PWTT(:, 2));

%% 步骤2：去除幅值不合要求的点
idx = find((PWTT(:, 2) > minPWTT) .* (PWTT(:, 2) < maxPWTT));
peakStartUsed = peakStartUsed(idx, :);
peakEndUsed = peakEndUsed(idx, :);
PWTT = PWTT(idx, :);
% hold on, plot(PWTT(:, 1), PWTT(:, 2), 'r');

%% 步骤3：去除异常点
[ PWTT, idx ] = removeOutlier( PWTT, 2, 10 );
peakStartUsed = peakStartUsed(idx, :);
peakEndUsed = peakEndUsed(idx, :);
% hold on, plot(PWTT(:, 1), PWTT(:, 2), 'g');


end
