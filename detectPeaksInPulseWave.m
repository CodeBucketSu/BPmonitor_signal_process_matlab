function [peaks,onsets,percent10s, percent50s, dicNotches, dicPeaks] = detectPeaksInPulseWave(data)
% detectPeaksInPulseWave 检测脉搏波的波峰、波谷、10%关键点

%% 步骤1：检测脉搏波峰
peaks = detetectPeaksInPulseWave(data, 60);  %

%% 步骤2：检测脉搏波起点，并与peaks对齐
onsets = detectOnsetsInPulseWave(data, peaks);
onsets = alignDataAccordingToReferenceData(onsets, peaks, -300, -10);

%% 步骤3：在每个心动周期的上升沿定位特征点：10%关键点,斜率最大点，并与peaks对齐
[percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks);
percent10s = alignDataAccordingToReferenceData(percent10s, peaks, -300, -10);
percent50s = alignDataAccordingToReferenceData(percent50s, peaks, -200, -10);

%% 步骤4：在每个心动周期的下降沿定位特征点：降中峡，重博波 ，并与peaks对齐
[dicNotches, dicPeaks] = detectCharacteristicPointsInDescendingLimbOfPulseWave(data, onsets, peaks);%,'WAVELET' 
dicNotches = alignDataAccordingToReferenceData(dicNotches, peaks, 50, 500);
dicPeaks = alignDataAccordingToReferenceData(dicPeaks, peaks, 50, 600);


% figure, hold on;
% plot(data, 'k');
% plot(peaks(:, 1), peaks(:, 2), 'ro');
% plot(onsets(:, 1), onsets(:, 2), 'ro');
% plot(percent10s(:, 1), percent10s(:, 2), 'r*');
% plot(percent50s(:, 1), percent50s(:, 2), 'r*');
% plot(dicNotches(:, 1), dicNotches(:, 2), 'b*');
% plot(dicPeaks(:, 1), dicPeaks(:, 2), 'g*');
% close;

end