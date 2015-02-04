function [dicNotch, dicPeak, zeroPassPointsNum ] = detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdge,range )
%DETECTDICNOTCHANDDICPEAKINDESCENDINGEDGEUSEWAVELET 执行以下几个步骤 重采样 ->
%求差分信号的小波变换 -> 找到特定过零点作为降中峡 ->根据降中峡的位置使用距离法查找重搏波
%   使用小波法在下降支中检测重博波和降中峡
%   输入
%   descendingEdge [N*1]矩阵 脉搏波下降支
%   range 使用衰减法计算出的当前距离法搜索范围
%   输出
%   zeroPassPointsNum 半心动周期内过零点的数量

%%参数与输出预定义
resampleInterval = 10;%减采样周期
dicNotch = -1;
dicPeak = -1;
%% 步骤1：信号段减采样与归一化 
data = descendingEdge;
dataPart = downsample(data,resampleInterval);
dataPart = dataPart/max(abs(dataPart));
%% 步骤2：求小波变换
wlp = waveletMethodB(dataPart);
%% 步骤3：降中峡位置
%   求小波变换的第4个过零点并增采样，作为降中峡位置
pos = findPassZeroPointPos(wlp(1:floor(end/2))) ;    
zeroPassPointsNum = length(pos);
if zeroPassPointsNum<4
	return
end
pos =  pos(4) * resampleInterval ;
%   将降中峡位置增采样，并在[-resampleInterval,resampleInterval]内寻找二阶导最大值点，作为降中峡原始波形位置
if pos + resampleInterval<=length(data) && pos - resampleInterval>0
        [~,shift] = max(abs(diff(data(pos- resampleInterval:pos + resampleInterval),2)));
        pos = pos + shift - resampleInterval; 
end
dicNotch = pos;
%% 步骤4：在[pos+1:pos+range-1]范围内寻找到包含[pos,data(pos)]与[pos+range,data(pos+range)]这两点的直线
%       的距离最近且处于直线上方的点，然后在起点到这点之间找波峰。如果找到了波峰，则将其位置作为重博波位置，否则使用终点位置
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

