function [peak,valley,key, rise, dicNotch, dicPeak] = detectPeaksInPulseWave(data)
% detectPeaksInPulseWave 检测脉搏波的波峰、波谷、10%关键点

len = length(data);
maxLenRet = ceil(len / 300);
peak = zeros(maxLenRet, 2);
valley = peak;
key = peak;
rise = peak;
dicNotch = peak;
dicPeak = peak;
num = 0;

%% 步骤1：利用翼函数缩小波峰可能存在的范围
wing50 = wingFunc(data, 50);
thres = mean(wing50(wing50 > 0));
idx = wing50 > thres;
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
idxs = find(idx);
idxs = idxs(idxs > 500);
idxs = idxs(idxs + 300 < length(data));
for i = 1 : length(idxs)
    idx = idxs(i);
    if diff(data(idx - 50:idx)) >= 0
        if diff(data(idx : idx + 70)) <= 0
            if data(idx) == max(data(idx -300 : idx + 300))
                num = num + 1;
                peak(num, :) = [idx, data(idx)];
            end
        end
    end
end

%% 步骤4：接下来要在每个波峰前寻找波谷,10%关键点,斜率最大点
for i = 1 : num
    pIdx = peak(i, 1);
    
    %% 步骤1：确认寻找范围起点：从该点起直到波峰处1阶导数都为正
    data4start = data(pIdx - 300 : pIdx);
    diff4start = diff(data4start);
    idxStart = find(diff4start < 0, 1, 'last');
    if length(idxStart) == 0
        idxStart = 0;
    end
    idxStart = pIdx - 300 + idxStart - 2;
    data4valley = data(idxStart : pIdx);
    
    %% 步骤2：确认寻找波谷点范围的终点，满足:
    %       1，2阶导数最大
    diff24valley = diff(data4valley, 2);
    idxEnd = find(diff24valley == max(diff24valley), 1, 'first');
    idxEnd = pIdx - (length(diff24valley) - idxEnd) - 2;
    
    %% 步骤3：定位波谷点，满足：
    %       1，在idxStart和idxEnd两点之间
    %       2，距离idxStart和idxEnd两点连线距离最远
    delta = (data(idxEnd) - data(idxStart)) / (idxEnd - idxStart);
    if idxEnd - idxStart  < 2
        vIdx = ceil((idxEnd + idxStart) / 2);
    else
        for idx = idxEnd - 1 : -1 : idxStart + 1
            if data(idx) - data(idx - 1) < delta && data(idx + 1) - data(idx) > delta
                vIdx = idx;
                valley(i, :) = [vIdx, data(vIdx)];
                break;
            end
        end
    end
    
    %% 步骤4：定位10%点，位于波谷点和波峰之间，幅值10%处
    idxKey = detectKpercentKeyPoint(data(vIdx : pIdx), 0.1);
    kIdx = pIdx - (pIdx - vIdx + 1 - idxKey);
    key(i, :) = [kIdx, data(kIdx)];
    
    %% 步骤5：定位斜率最大点，位于波谷和波峰之间，1阶导数最大点
    diff4rise = diff(data(vIdx : pIdx));
    idxRise = find(diff4rise == max(diff4rise), 1, 'first');
    rIdx = pIdx - (pIdx - vIdx + 1 - idxRise);
    rise(i, :) = [rIdx, data(rIdx)];
    
    %% 步骤6：定位降中峡，满足以下规则：
    %          1，在波峰后100--300个点之间
    %          2，第一个波谷（斜率由负转正）
    data4dn = data(pIdx + 100 : pIdx + 300);
    diff4dn = diff(data4dn);
    diff4dn = [0; diff4dn];
    wing4dn = wingFunc(data4dn, 1);
    idx4dn = (diff4dn < 0) .* (wing4dn > 0);
    dnIdx = find(idx4dn>0, 1, 'first');
    if (isempty(dnIdx))
        dicNotch(i, :) = [-1, 0];
    else
        dnIdx = dnIdx  + pIdx + 99;
        dicNotch(i, :) = [dnIdx, data(dnIdx)];
    end
    
    %% 步骤7：定位重博波波峰
    if(~isempty(dnIdx) && dnIdx + 300 < length(data))
        data4dp = data(dnIdx + 1 : dnIdx + 300);
        dpIdx = find(data4dp == max(data4dp), 1, 'first');
        dpIdx = dpIdx + dnIdx;
        dicPeak(i, :) = [dpIdx, data(dpIdx)];
    end
    
end

%% 步骤5：保留有效值
peak = peak(1:num, :);
valley = valley(1:num, :);
key = key(1:num, :);
rise = rise(1:num, :);

end

function [idx] = detectKpercentKeyPoint(risingEdge, percent)
% [idx] = detectKpercentKeyPoint(data, K) 在上升沿中定位幅值百分点
% idx：位置
% risingEdge：上升沿数据，头是最小值，尾是最大值
% percent：百分比
keyVal = risingEdge(1) + percent * (risingEdge(end) - risingEdge(1));
delta4key = abs(risingEdge - keyVal);
idx = find(delta4key == min(delta4key), 1,  'first');

end