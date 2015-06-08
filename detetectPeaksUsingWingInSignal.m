function [peaks] = detetectPeaksUsingWingInSignal(data, peakWidth)
% function [peaks] = detetectPeaksUsingWingInSignal(data) 在目标信号中检测出满足条件的峰值
% 输入：
%   data：目标信号
%   peakWidth：波的估计宽度
% 输出：
%   peaks：  N x 2   分别是波峰的位置和波峰的幅值
threshold = floor(getPlethParas(1)*3/10);
minVal = floor(getPlethParas(1)*5/10);

len = length(data);
maxLenRet = ceil(len / threshold);
peaks = zeros(maxLenRet, 2);
num = 0;

%% 步骤1：利用翼函数缩小波峰可能存在的范围
win = floor(peakWidth/2);
wingWidth = wingFunc(data, win);
thres = mean(wingWidth(wingWidth > 0));
idx = wingWidth > thres;
wing10 = wingFunc(data, 10);
idx = idx .* (wing10 > 0);
wing3 = wingFunc(data, 3);
idx = idx .* (wing3 > 0);

%% 步骤2：利用一阶导数缩小范围
data4diff1 = [data(1); data];
d1 = diff(data4diff1);
idx = idx .* (d1 > 0);

%% 步骤3：遍历可能点，满足两个条件则为波峰：
%       1，前70点1阶导数为正，后100点一阶导数为负；
%       2，为前后300点内的最大值
bottomVal = floor(getPlethParas(1)*5/100);
upVal = floor(getPlethParas(1)*7/100);

idxs = find(idx);
idxs = idxs(idxs > minVal);
idxs = idxs(idxs + threshold < length(data));
for i = 1 : length(idxs)
    idx = idxs(i);
    if diff(data(idx - bottomVal:idx)) >= 0
        if diff(data(idx : idx + upVal)) <= 0
            if data(idx) == max(data(idx -threshold : idx + threshold))
                num = num + 1;
                peaks(num, :) = [idx, data(idx)];
            end
        end
    end
end
peaks = peaks(1:num, :);

end