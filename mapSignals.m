function [dataMapStart, dataMapEnd] = mapSignals(dataStart, dataEnd)
%MAPSIGNALS(dataStart, dataEnd, index) ����·�����н����ж�Ӧ�㱣��������
% ��һ���ź�ȥ����Щ����һ���ź����Ҳ�����Ӧ��ĵ㡣
% dataStart, dataEnd�� ���� lenth * N �����ݣ����е�1�б�ʾ���λ��
% index: ����ָ����һ�н����ڶ�Ӧ����ж�

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
        % �ҵ�һ���Ӧ��
        num = num + 1;
        dataMapStart(num, :) = dataStart(i, :);
        dataMapEnd(num, :) = dataEnd(j, :);
    else 
        % ��ǰ��û�ж�Ӧ��
        continue;
    end
    
end
dataMapStart = dataMapStart(1:num, :);
dataMapEnd = dataMapEnd(1:num, :);

end