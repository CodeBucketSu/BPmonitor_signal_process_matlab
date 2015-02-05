function [onsets] = detectOnsetsInPulseWave(data, peaks)
% function [onsets] = detectOnsetsInSignals(data, peaks) 在检测到波峰后，检测脉搏波起始点
% 输入：
%   data：目标信号
%   peaks：  N x 2   波峰，分别为波峰位置和波峰幅值
% 输出：
%   onsets： N x 2   起始点，分别为位置和幅值
peaks = peaks(peaks(:, 1) > 300, :);
onsets = zeros(size(peaks));
%% 步骤1：在每个波峰前寻找波谷,
for i = 1 : size(peaks, 1)
    pIdx = peaks(i, 1);
    
    %% 步骤1：确认寻找范围起点：从该点后50点起直到波峰处1阶导数都为正
    data4start = data(pIdx - 300 : pIdx);
    diff4start = diff(data4start);
    idxStart = find(diff4start < 0, 1, 'last');
    if length(idxStart) == 0
        idxStart = 0;
    end
    idxStart = pIdx - 300 + idxStart - 2 - 50;
    data4valley = data(idxStart : pIdx);
    
    %% 步骤2：确认寻找波谷点范围的终点，满足:
    %       1，2阶导数最大
    diff24valley = diff(data4valley, 2);
    idxEnd = find(diff24valley == max(diff24valley), 1, 'first');
    idxEnd = pIdx - (length(diff24valley) - idxEnd) - 2;
    
    %% 步骤3：定位波谷点，满足：
    %       1，在idxStart和idxEnd两点之间
    %       2，距离idxStart和idxEnd两点连线距离最远
    if idxEnd - idxStart  < 2
        vIdx = ceil((idxEnd + idxStart) / 2);
        onsets(i, :) = [vIdx, data(vIdx)];
    else
        [~,vIdx] = poinToLineDistance([idxStart:idxEnd; data(idxStart:idxEnd).'].',...
            [idxStart, data(idxStart)],[idxEnd, data(idxEnd)],0);
        vIdx = idxStart + vIdx - 1;
        onsets(i, :) = [vIdx, data(vIdx)];
%         delta = (data(idxEnd) - data(idxStart)) / (idxEnd - idxStart);
%         for idx = idxEnd - 1 : -1 : idxStart + 1
%             if data(idx) - data(idx - 1) < delta && data(idx + 1) - data(idx) > delta
%                 vIdx = idx;
%                 onsets(i, :) = [vIdx, data(vIdx)];
%                 break;
%             end
%         end
    end
end

end