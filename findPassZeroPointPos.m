function [pos] = findPassZeroPointPos(data)
%%��һ����ɢ���ݵĽ��ƹ����
%  ����:
%  data: Nά��ɢ����(N>2)
%  ���:
%  pos : ��ɢ�����н��ƹ�����λ��
% Ԥ��������
if min(data)>1 || length(data)<3
    pos = [];
    return
end
%% ��������λ��˵Ľ��
plusResult = data(1:end-1).*data(2:end);
%% �ҵ�С��0�����ݵ��λ��
pos = find(double(plusResult<=0));
for i=1:length(pos)
    if abs(data(pos(i))) > abs(data(pos(i) + 1))
        pos(i) = pos(i)+1;
    end
end