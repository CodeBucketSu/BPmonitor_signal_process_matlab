function [isTrue] = isTooManyPeaksRemoved(peaks, peaks_used)
% function [isTrue] = isTooManyPeaksRemoved(peaks, peaksUsed)
% ���ؼ���Ͷ�Ӧ�ı�ʹ�õĹؼ����Ƿ����̫��
% peaks���ؼ����б�Ԫ������
% peaksUsed����Ӧ��ʹ�õĹؼ����б�Ԫ������
isTrue = 0;
for i = 1 : length(peaks)
    peak = peaks{i};
    peak_used = peaks_used{i};
    len = length(peak);
    lenUsed = length(peak_used);
    lenDelta = len - lenUsed;

    isTrue = isTrue || (lenDelta > 3 && lenDelta > len * 0.1) ...
        || lenDelta > len * 0.4;
end



end