function [dicNotch, dicPeak] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, method)
% [dicNotch, dicPeak] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge)
% ���½�֧�м���ز����ͽ���Ͽ

if strcmp(method, 'WAVELET')
    %%
else
    len = length(descendingEdge);
    baseline = descendingEdge(1) + [0:len-1] .* (descendingEdge(end) - descendingEdge(1)) ./ len;
    sigNoBase = descendingEdge - baseline.';
    startIdx4Notch = floor(len * 1/8);
    startIdx4Peak = floor(len * 1/4);
    dicNotch = locateMin(sigNoBase(startIdx4Notch : floor(len * 1/3)), 'first') + startIdx4Notch - 1;
    dicPeak = locateMax(sigNoBase(startIdx4Peak : floor(len * 1/2)), 'first') + startIdx4Peak - 1;

    %% ������ǰ��ߵ����򷵻�[-1, 0]
    if dicPeak < dicNotch 
        dicPeak = -1;
        dicNotch = -1;
        return 
    end

    %% ����ѡ��ķ����������ն�λ
    if strcmp(method, 'PEAK')
        % �����еĽ���Ͽ���ز�����֮����������Ͳ���
        dicNotchOffset = locateMin(descendingEdge(dicNotch : dicPeak), 'first');
        dicNotch = dicNotch + dicNotchOffset - 1;
        dicPeakOffset = locateMax(descendingEdge(dicNotch : dicPeak), 'first');
        dicPeak = dicNotch + dicPeakOffset - 1;
    elseif strcmp(method, 'DISTANCE')
        [dicNotchOffset,  dicPeakOffset] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge(dicNotch : dicPeak), 'NONE');
        dicNotch = dicNotch + dicNotchOffset - 1;
        dicPeak = dicNotch + dicPeakOffset - 1;  
    end
end

else

%% ������ǰ��ߵ����򷵻�[-1, 0]
if dicPeak < dicNotch 
    dicPeak = -1;
    dicNotch = -1;
    return 
end

end