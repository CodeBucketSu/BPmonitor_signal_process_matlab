function [dicNotch, dicPeak, zeroPassPointsNum ] = detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdge,range )
%DETECTDICNOTCHANDDICPEAKINDESCENDINGEDGEUSEWAVELET ִ�����¼������� �ز��� ->
%�����źŵ�С���任 -> �ҵ��ض��������Ϊ����Ͽ ->���ݽ���Ͽ��λ��ʹ�þ��뷨�����ز���
%   ʹ��С�������½�֧�м���ز����ͽ���Ͽ
%   ����
%   descendingEdge [N*1]���� �������½�֧
%   range ʹ��˥����������ĵ�ǰ���뷨������Χ
%   ���
%   zeroPassPointsNum ���Ķ������ڹ���������

%%���������Ԥ����
resampleInterval = 10;%����������
dicNotch = -1;
dicPeak = -1;
%% ����1���źŶμ��������һ�� 
data = descendingEdge;
dataPart = downsample(data,resampleInterval);
dataPart = dataPart/max(abs(dataPart));
%% ����2����С���任
wlp = waveletMethodB(dataPart);
%% ����3������Ͽλ��
%   ��С���任�ĵ�4������㲢����������Ϊ����Ͽλ��
pos = findPassZeroPointPos(wlp(1:floor(end/2))) ;    
zeroPassPointsNum = length(pos);
if zeroPassPointsNum<4
	return
end
pos =  pos(4) * resampleInterval ;
%   ������Ͽλ��������������[-resampleInterval,resampleInterval]��Ѱ�Ҷ��׵����ֵ�㣬��Ϊ����Ͽԭʼ����λ��
if pos + resampleInterval<=length(data) && pos - resampleInterval>0
        [~,shift] = max(abs(diff(data(pos- resampleInterval:pos + resampleInterval),2)));
        pos = pos + shift - resampleInterval; 
end
dicNotch = pos;
%% ����4����[pos+1:pos+range-1]��Χ��Ѱ�ҵ�����[pos,data(pos)]��[pos+range,data(pos+range)]�������ֱ��
%       �ľ�������Ҵ���ֱ���Ϸ��ĵ㣬Ȼ������㵽���֮���Ҳ��塣����ҵ��˲��壬����λ����Ϊ�ز���λ�ã�����ʹ���յ�λ��
tmp = data(pos+1:pos+range-1);
[~,maxpos,~] = poinToLineDistance([pos+1:pos+range-1;tmp(:)']',...
    [pos,data(pos)],[pos+range,data(pos+range)],1);
tmp = findPeakShiftInData(data(pos:pos+maxpos));
if tmp~=-1
    dicPeak = pos+tmp-1;
else
    dicPeak = pos+maxpos;
end
end

