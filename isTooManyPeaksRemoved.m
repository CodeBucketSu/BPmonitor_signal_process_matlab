function [isTrue] = isTooManyPeaksRemoved(peaks, peaks_used)
% function [isTrue] = isTooManyPeaksRemoved(peaks, peaksUsed)
% 检测关键点和对应的被使用的关键点是否相差太多
% peaks：关键点列表，元胞数组
% peaksUsed：对应的使用的关键点列表，元胞数组
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