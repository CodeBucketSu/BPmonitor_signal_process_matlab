function [dicNotch, dicPeak] = detectDicNotchANdDicPeakInDesceningEdgeUsePeak( descendingEdge )
len = length(descendingEdge);
baseline = descendingEdge(1) + [0:len-1] .* (descendingEdge(end) - descendingEdge(1)) ./ len;
sigNoBase = descendingEdge - baseline.';
startIdx4Notch = floor(len * 1/8);
startIdx4Peak = floor(len * 1/4);
dicNotch = locateMin(sigNoBase(startIdx4Notch : floor(len * 1/3)), 'first') + startIdx4Notch - 1;
dicPeak = locateMax(sigNoBase(startIdx4Peak : floor(len * 1/2)), 'first') + startIdx4Peak - 1;

if dicPeak < dicNotch 
    dicPeak = -1;
    dicNotch = -1;
    return 
end

dicNotchOffset = locateMin(descendingEdge(dicNotch : dicPeak), 'first');
dicNotch = dicNotch + dicNotchOffset - 1;
dicPeakOffset = locateMax(descendingEdge(dicNotch : dicPeak), 'first');
dicPeak = dicNotch + dicPeakOffset - 1;

if dicPeak < dicNotch 
    dicPeak = -1;
    dicNotch = -1;
    return 
end
end