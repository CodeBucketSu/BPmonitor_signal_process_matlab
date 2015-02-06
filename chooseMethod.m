function [ pwfstat_best, methodNum ] = chooseMethod( pwfstats )
% [ pwfstat_best ] = chooseMethod( pwfstat_peak, pwfstat_distance, pwfstat_wavelet )
% 在三种计算降中峡，重博波的方法中出来的结果中挑选一个，根据第 3,4,5,6,26,30,32,33 个参数进行选择
% 输入：三种方法计算得到的结果
% 输出：挑选的方法对应的结果和方法

IDXS2CMP = [3,4,5,6,26,30,32,33];

points = zeros(3, 1);

for i = 1 : length(IDXS2CMP)
    idx = IDXS2CMP(i);
    points = points + compareFeatureCorr({pwfstats{1}(idx, :), ...
         pwfstats{2}(idx, :), pwfstats{3}(idx, :)});
end

methodNum = find(points == max(points(:)), 1, 'first');
pwfstat_best = pwfstats{methodNum};

end

