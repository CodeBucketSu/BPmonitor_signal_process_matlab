function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% 在目标信号中检测出满足条件的峰值，用传入的心率验证正确性
% 输入：
%   data：目标信号
%   HR4ref：参考心率
% 输出：
%   peaks：  N x 2   分别是波峰的位置和波峰的幅值

peakWidth = floor(getSampleRate(2)/10);

peaks = detetectPeaksUsingWingInSignal(data, peakWidth);


end