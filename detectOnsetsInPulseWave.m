function [onsets] = detectOnsetsInPulseWave(data, peaks)
% function [onsets] = detectOnsetsInSignals(data, peaks) �ڼ�⵽����󣬼����������ʼ��
% ���룺
%   data��Ŀ���ź�
%   peaks��  N x 2   ���壬�ֱ�Ϊ����λ�úͲ����ֵ
% �����
%   onsets�� N x 2   ��ʼ�㣬�ֱ�Ϊλ�úͷ�ֵ
peaks = peaks(peaks(:, 1) > 300, :);
onsets = zeros(size(peaks));
%% ����1����ÿ������ǰѰ�Ҳ���,
for i = 1 : size(peaks, 1)
    pIdx = peaks(i, 1);
    
    %% ����1��ȷ��Ѱ�ҷ�Χ��㣺�Ӹõ��50����ֱ�����崦1�׵�����Ϊ��
    data4start = data(pIdx - 300 : pIdx);
    diff4start = diff(data4start);
    idxStart = find(diff4start < 0, 1, 'last');
    if length(idxStart) == 0
        idxStart = 0;
    end
    idxStart = pIdx - 300 + idxStart - 2 - 50;
    data4valley = data(idxStart : pIdx);
    
    %% ����2��ȷ��Ѱ�Ҳ��ȵ㷶Χ���յ㣬����:
    %       1��2�׵������
    diff24valley = diff(data4valley, 2);
    idxEnd = find(diff24valley == max(diff24valley), 1, 'first');
    idxEnd = pIdx - (length(diff24valley) - idxEnd) - 2;
    
    %% ����3����λ���ȵ㣬���㣺
    %       1����idxStart��idxEnd����֮��
    %       2������idxStart��idxEnd�������߾�����Զ
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