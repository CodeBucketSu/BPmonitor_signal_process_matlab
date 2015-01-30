function [dataStartMatched, dataEndMatched] = match2data(dataAhead, dataAfter, maxInterval)
%MAPSIGNALS(dataAhead, dataAfter) ����·�����н����ж�Ӧ�㱣��������
% ��һ���ź�ȥ����Щ����һ���ź����Ҳ�����Ӧ��ĵ㡣
% dataAhead, dataAfter�� ���� lenth * N �����ݣ����е�1�б�ʾ���λ��
% index: ����ָ����һ�н����ڶ�Ӧ����ж�

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
        % �ҵ�һ���Ӧ��
        num = num + 1;
        dataStartMatched(num, :) = dataAhead(i, :);
        dataEndMatched(num, :) = dataAfter(j, :);
    else 
        % ��ǰ��û�ж�Ӧ��
        continue;
    end
    
end
dataStartMatched = dataStartMatched(1:num, :);
dataEndMatched = dataEndMatched(1:num, :);

end