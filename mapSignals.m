function [dataMapStart, dataMapEnd] = mapSignals(dataStart, dataEnd)
%MAPSIGNALS(dataStart, dataEnd, index) 从两路数据中将所有对应点保留下来，
% 从一个信号去除那些在另一个信号中找不到对应点的点。
% dataStart, dataEnd： 都是 lenth * N 的数据，其中第1列表示点的位置
% index: 用于指明哪一列将用于对应点的判断

maxInter = max(dataEnd(2 : end) - dataEnd(1 : end - 1));

j = 1;
lenEnd = size(dataEnd, 1);
lenStart = size(dataStart, 1);
len = min([lenEnd, lenStart]);
dataMapStart  = zeros(len, size(dataStart, 2));
dataMapEnd = dataMapStart;

num = 0;
for i = 1 : lenStart
    while j < lenEnd && dataEnd(j, 1) < dataStart(i, 1)
        j = j + 1;
    end
    if j > lenEnd
        break;
    end
    if dataEnd(j, 1) - dataStart(i, 1) < maxInter ...
            && (i < lenStart && dataStart(i + 1, 1) > dataEnd(j, 1) || i == lenStart)
        % 找到一组对应点
        num = num + 1;
        dataMapStart(num, :) = dataStart(i, :);
        dataMapEnd(num, :) = dataEnd(j, :);
    else 
        % 当前点没有对应点
        continue;
    end
    
end
dataMapStart = dataMapStart(1:num, :);
dataMapEnd = dataMapEnd(1:num, :);

end