function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% ��Ŀ���ź��м������������ķ�ֵ���ô����������֤��ȷ��
% ���룺
%   data��Ŀ���ź�
%   HR4ref���ο�����
% �����
%   peaks��  N x 2   �ֱ��ǲ����λ�úͲ���ķ�ֵ

% peakWidth = floor(getSampleRate(2)/10);
peakWidth = getSampleRate();

peaks = detetectPeaksUsingWingInSignal(data, peakWidth);


end