function [peaks,onsets]=detectPeakAndOnsetsInBPWave(data)
%% ������Ѫѹ�����м������ѹ������ѹλ��

%% ����1�������������
peaks = detetectPeaksInPulseWave(data, 60);  

%% ����2�������������㣬����peaks����
onsets_tmp = detectOnsetsInPulseWave(data, peaks);
onsets = alignDataAccordingToReferenceData(onsets_tmp, peaks, floor(getSampleRate(2) /1000 * -300), -10);

%% ����3���Ƴ��Ƿ�������
onsets = onsets(onsets(:, 1)~=-1);
%error = find(onsets(:, 1) == -1);
%if length(error) > 0
%    input('error');
%end
end
