function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% function [peaks] = detetectPeaksInPulseWave(data, HR4ref)
% ��Ŀ���ź��м������������ķ�ֵ���ô����������֤��ȷ��
% ���룺
%   data��Ŀ���ź�
%   HR4ref���ο�����
% �����
%   peaks��  N x 2   �ֱ��ǲ����λ�úͲ���ķ�ֵ

peaks = detetectPeaksUsingWingInSignal(data, 100);


end