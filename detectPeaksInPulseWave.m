function [peaks,onsets,percent10s, percent50s, dicNotches, dicPeaks] = detectPeaksInPulseWave(data)
% detectPeaksInPulseWave ����������Ĳ��塢���ȡ�10%�ؼ���

%% ����1�������������
peaks = detetectPeaksInPulseWave(data, 60);  %

%% ����2�������������㣬����peaks����
onsets = detectOnsetsInPulseWave(data, peaks);
onsets = alignDataAccordingToReferenceData(onsets, peaks, -300, -10);

%% ����3����ÿ���Ķ����ڵ������ض�λ�����㣺10%�ؼ���,б�����㣬����peaks����
[percent10s, percent50s] = detectCharacteristicPointsInAscendingEdgeOfPulseWave(data, onsets, peaks);
percent10s = alignDataAccordingToReferenceData(percent10s, peaks, -300, -10);
percent50s = alignDataAccordingToReferenceData(percent50s, peaks, -200, -10);

%% ����4����ÿ���Ķ����ڵ��½��ض�λ�����㣺����Ͽ���ز��� ������peaks����
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