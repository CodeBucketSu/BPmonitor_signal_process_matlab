function [peak,valley,key, rise] = detectPeaksInPulseWave(data)
% detectPeaksInPulseWave ����������Ĳ��塢���ȡ�10%�ؼ���

len = length(data);
maxLenRet = ceil(len / 300);
peak = zeros(maxLenRet, 2);
valley = peak;
key = peak;
rise = peak;
num = 0;

%% ����1������������С������ܴ��ڵķ�Χ
wing50 = wingFunc(data, 50);
thres = mean(wing50(wing50 > 0));
idx = wing50 > thres;
wing10 = wingFunc(data, 10);
idx = idx .* (wing10 > 0);
wing3 = wingFunc(data, 3);
idx = idx .* (wing3 > 0);

%% ����2������һ�׵�����С��Χ
data4diff1 = [data(1); data];
d1 = diff(data4diff1);
idx = idx .* (d1 > 0);

%% ����3���������ܵ㣬��������������Ϊ���壺
%       1��ǰ70��1�׵���Ϊ������100��һ�׵���Ϊ����
%       2��Ϊǰ��300���ڵ����ֵ
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

%% ����4��������Ҫ��ÿ������ǰѰ�Ҳ���,10%�ؼ���,б������
for i = 1 : num
    pIdx = peak(i, 1);
    
    %% ����1��ȷ��Ѱ�ҷ�Χ��㣺�Ӹõ���ֱ�����崦1�׵�����Ϊ��
    data4start = data(pIdx - 300 : pIdx);
    diff4start = diff(data4start);
    idxStart = find(diff4start < 0, 1, 'last');
    if length(idxStart) == 0
        idxStart = 0;
    end
    idxStart = pIdx - 300 + idxStart - 2;
    data4valley = data(idxStart : pIdx);
    
    %% ����2��ȷ��Ѱ�Ҳ��ȵ㷶Χ���յ㣬����:
    %       1��2�׵������
    diff24valley = diff(data4valley, 2);
    idxEnd = find(diff24valley == max(diff24valley), 1, 'first');
    idxEnd = pIdx - (length(diff24valley) - idxEnd) - 2;
    
    %% ����3����λ���ȵ㣬���㣺
    %       1����idxStart��idxEnd����֮��
    %       2������idxStart��idxEnd�������߾�����Զ
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
    
    %% ����4����λ10%�㣬λ�ڲ��ȵ�Ͳ���֮�䣬��ֵ10%��
    keyVal = data(vIdx) + 0.1 * (data(pIdx) - data(vIdx));
    delta4key = abs(data(vIdx : pIdx) - keyVal);
    idxKey = find(delta4key == min(delta4key), 1,  'first');
    kIdx = pIdx - (length(delta4key) - idxKey);
    key(i, :) = [kIdx, data(kIdx)];
    
    %% ����5����λѩ�����㣬λ�ڲ��ȺͲ���֮�䣬1�׵�������
    diff4rise = diff(data(vIdx : pIdx));
    idxRise = find(diff4rise == max(diff4rise), 1, 'first');
    rIdx = pIdx - (length(delta4key) - idxRise);
    rise(i, :) = [rIdx, data(rIdx)];
    
end

%% ����5��������Чֵ
peak = peak(1:num, :);
valley = valley(1:num, :);
key = key(1:num, :);
rise = rise(1:num, :);

end