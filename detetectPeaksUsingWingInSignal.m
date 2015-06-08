function [peaks] = detetectPeaksUsingWingInSignal(data, peakWidth)
% function [peaks] = detetectPeaksUsingWingInSignal(data) ��Ŀ���ź��м������������ķ�ֵ
% ���룺
%   data��Ŀ���ź�
%   peakWidth�����Ĺ��ƿ��
% �����
%   peaks��  N x 2   �ֱ��ǲ����λ�úͲ���ķ�ֵ
threshold = floor(getPlethParas(1)*3/10);
minVal = floor(getPlethParas(1)*5/10);

len = length(data);
maxLenRet = ceil(len / threshold);
peaks = zeros(maxLenRet, 2);
num = 0;

%% ����1������������С������ܴ��ڵķ�Χ
win = floor(peakWidth/2);
wingWidth = wingFunc(data, win);
thres = mean(wingWidth(wingWidth > 0));
idx = wingWidth > thres;
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