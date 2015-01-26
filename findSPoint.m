function [pos,val] = findSPoint(data, marker)
% �����ҵ�һ����������͹������λ��
% ����
% data-[N,2]ԭʼ�������ݶ�
% marker-[1,1]�����Ҫ����͹�㻹�ǰ��� 1-͹�� 0-����
% ���
% pos-[1,1]λ�á����δ�ҵ�������ȡֵΪ-1
% val-[1,1]λ�ö�Ӧ��ȡֵ
%% ��ʼ��
% ����һ���洢���λ�õ�����
pos = -1;
val = 0;
ds = [5,10,15,20,25,30];
tmp = (length(data(:,1)) - 2*ds(end));
if(tmp <= 0)
    return;
end
    
%% ���岢����洢�����ϸ����㵽����ƽ�����������
dists = zeros(1,tmp);
tmpArray = zeros(1,length(ds));
for i=ds(end)+1:tmp+ds(end)
    for j=1:length(ds)            
        [distance,~,relation] = poinToLineDistance(data(i,:),data(i-ds(j),:),data(i+ds(j),:));
        if isempty(distance)
            continue;
        end
        tmpArray(j) = relation * distance;
    end
    if ~(~isempty(double(tmpArray>0))&&~isempty(double(tmpArray>0))...
            &&((isempty(double(tmpArray>0))&&marker == 1)||(isempty(double(tmpArray>0))&&marker == 0)))
                dists(i-ds(end)) = mean(abs(tmpArray));
    end
end

%% ����Markerȷ��͹��򰼵��λ��
if marker == 1 || marker==0
    [~,pos]=max(dists);
    if marker == 1
        pos=pos(end);
    else
        pos=pos(1);
    end
    pos=pos+ds(end);
    val=data(pos,2);
else
    return;
end