function [points] = compareFeatureCorr(fstats)
% function [p_p, p_d, p_w] = compareFeatureCorr(fstat_peak, fstat_distance, fstat_wavelet)
% 比较三个数据并给出对应的得分

p_p = 0;
p_d = 0;
p_w = 0;

points = [p_p; p_d; p_w];

for i = 1:length(fstats)
    corr = abs(fstats{i});
    if corr(1) > 0.5 && corr(2) < 0.1
        points(i) = points(i) + corr(1) - 0.5
    end
    if corr(3) > 0.5 && corr(4) < 0.1
        points(i) = points(i) + corr(3) - 0.5
    end
end

end