function [pos,val] = findSPoint(data, marker)
% 用于找到一段曲线中最凸或最凹点的位置
% 输入
% data-[N,2]原始曲线数据段
% marker-[1,1]标记需要的是凸点还是凹点 1-凸点 0-凹点
% 输出
% pos-[1,1]位置。如果未找到，则令取值为-1
% val-[1,1]位置对应的取值
%% 初始化
% 定义一个存储相对位置的数组
pos = -1;
val = 0;
ds = [5,10,15,20,25,30];
tmp = (length(data(:,1)) - 2*ds(end));
if(tmp <= 0)
    return;
end
    
%% 定义并计算存储曲线上各个点到各弦平均距离的数组
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

%% 根据Marker确定凸点或凹点的位置
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