function [dicNotch, dicPeak] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge, method)
% [dicNotch, dicPeak] = detectDicNotchAndDicPeakInDescendingEdge(descendingEdge)
% 在下降支中检测重博波和降中峡

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

    %% 如果结果前后颠倒，则返回[-1, 0]
    if dicPeak < dicNotch 
        dicPeak = -1;
        dicNotch = -1;
        return 
    end

    %% 根据选择的方法进行最终定位
    if strcmp(method, 'PEAK')
        % 在现有的降中峡和重博波峰之间检测脉波峰和波谷
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

%% 如果结果前后颠倒，则返回[-1, 0]
if dicPeak < dicNotch 
    dicPeak = -1;
    dicNotch = -1;
    return 
end

end