function [dataStartMatched, dataEndMatched] = match2data(dataAhead, dataAfter, maxInterval)
%MAPSIGNALS(dataAhead, dataAfter) 从两路数据中将所有对应点保留下来，
% 从一个信号去除那些在另一个信号中找不到对应点的点。
% dataAhead, dataAfter： 都是 lenth * N 的数据，其中第1列表示点的位置
% index: 用于指明哪一列将用于对应点的判断

j = 1;
lenEnd = size(dataAfter, 1);
lenStart = size(dataAhead, 1);
len = min([lenEnd, lenStart]);
dataStartMatched  = zeros(len, size(dataAhead, 2));
dataEndMatched = dataStartMatched;

num = 0;
for i = 1 : lenStart
    while j <= lenEnd && dataAfter(j, 1) < dataAhead(i, 1)
        j = j + 1;
    end
    if j > lenEnd
        break;
    end
    if dataAfter(j, 1) - dataAhead(i, 1) < maxInterval ...
            && (i < lenStart && dataAhead(i + 1, 1) > dataAfter(j, 1) || i == lenStart)
        % 找到一组对应点
        num = num + 1;
        dataStartMatched(num, :) = dataAhead(i, :);
        dataEndMatched(num, :) = dataAfter(j, :);
    else 
        % 当前点没有对应点
        continue;
    end
    
end
dataStartMatched = dataStartMatched(1:num, :);
dataEndMatched = dataEndMatched(1:num, :);

end