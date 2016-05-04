function [peaks,onsets]=detectPeakAndOnsetsInBPWave(data)
%% 从连续血压数据中检测舒张压与收缩压位置

%% 步骤1：检测脉搏波峰
peaks = detetectPeaksInPulseWave(data, 60);  

%% 步骤2：检测脉搏波起点，并与peaks对齐
onsets_tmp = detectOnsetsInPulseWave(data, peaks);
onsets = alignDataAccordingToReferenceData(onsets_tmp, peaks, floor(getSampleRate(2) /1000 * -300), -10);

%% 步骤3：移除非法的数据
onsets = onsets(onsets(:, 1)~=-1);
%error = find(onsets(:, 1) == -1);
%if length(error) > 0
%    input('error');
%end
end
