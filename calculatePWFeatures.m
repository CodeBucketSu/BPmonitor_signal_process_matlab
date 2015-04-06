function [features,featureNames] = calculatePWFeatures(pw,peaks,valleys,dicNotchs,dicPeaks)
%计算逐拍脉搏波特征
%设定:peaks与valleys第一维不一定会同时为-1,但dicNotchs与dicPeaks第一维一定会同时为-1
%亦即一定会同时检测到降中峡与重搏波,但不一定会同时检测到波峰与波谷
%输入：
%   pw:脉搏波信号 N*1
%   peaks,valleys,dicNotchs,dicPeaks:[P*2]波峰/波谷/降中峽/重博波的位置-信号值序列
%   要求四个信号的长度必须相同
%输出:
%   features,featureNames:特征/特征名元胞数组 K*2 [峰值位置,特征值]
%各种逐拍特征名及其含义见文档

%% 初始化35个特征名
featureNames = {'PH','PRT','DNH','DNHr','DPH','DPHr','PWA','RBAr','DBAr','DiaAr',...
'SLP1','SLP2','SLP3','RBW10','RBW25','RBW33','RBW50','RBW66','RBW75','DBW10','DBW25','DBW33','DBW50','DBW66','DBW75',...
'DNPT','KVAL','AmBE','DfAmBE','DNC','SC','DPW','DPWr','PDNT','PDPT'...
};
%% 初始化每个特征
features = featureNames;
for i=1:length(featureNames)
    features{i} = [-1,0];
end
%后4个输入的长度必须都为N - 否则出错
N = length(peaks(:,1));
if N<2
    return
end
if length(dicPeaks(:,1))~=N ||length(dicNotchs(:,1))~=N || length(valleys(:,1))~=N
    error('特征点检测输入有误');
end
%存储检出峰值波形的位置
pPeaks=peaks(:,1)>0;
%存储检出谷值波形的位置
pValleys=valleys(:,1)>0;
%存储同时检出峰谷值波形的位置
pBoth=pPeaks&pValleys;
%首先计算谷-谷值阈值
valley2valleyDists=valleys(pValleys,1);
valley2valleyDists=valley2valleyDists(2:end) - valley2valleyDists(1:end-1);
threshold=median(valley2valleyDists)*1.5;
%首先计算峰-峰值阈值
peak2peakDists=peaks(pPeaks,1);
peak2peakDists=peak2peakDists(2:end) - peak2peakDists(1:end-1);
pThreshold=median(peak2peakDists)*1.5;

%降中峽/重博波预处理
dicNotchs = dicNotchs(1:N,:);
dicPeaks = dicPeaks(1:N,:);
if dicNotchs(1,1)>0 && dicNotchs(1,1)<valleys(1,1)% 说明第一个波形有降中峽但没有波谷
    dicNotchs(1,1) = -1;
    dicPeaks(1,1) = -1;
end

%存储检出降中峡/重搏波的位置
indexes = dicNotchs(:,1) > 0;
%将indexes最后一个数字置零形成的数组，用于避免计算需要波谷的参数时越界
indexesEndWith0 = indexes;
indexesEndWith0(end) = 0;
%notchLen = sum(indexes);
minPW = min(pw);

%% 判断这段数据是否能够用于计算降中峽相关特征
calcNotch = 1;
if length(dicNotchs)<3
    calcNotch=0;
end

%% 计算主波高度 - 要求同时有峰谷值
features{1} = peaks- valleys(:,2)*[0,1];

%% 计算上升时间 - 要求同时有峰谷值
features{2} = peaks(pBoth,1)*[1,1] - valleys(pBoth,1)*[0,1];

%%
if calcNotch>0
%     %计算波谷至降中峡传播时间 - 要求同时有降中峡与谷值
%     tmp1 = dicNotchs(indexes&pValleys,1) - valleys(indexes&pValleys,1);
%     features{34} = [peaks(indexes&pValleys,1) tmp1];
    %计算波谷至重博波传播时间 - 要求同时有重博波与谷值    
%     tmp1 = dicPeaks(indexes&pValleys,1) - valleys(indexes&pValleys,1);
%     features{35} = [peaks(indexes&pValleys,1) tmp1];
    %计算降中峽高度 - 要求同时有降中峡与谷值
    tmp1 = dicNotchs(indexes&pValleys,2) - valleys(indexes&pValleys,2);
    features{3} = [peaks(indexes&pValleys,1) tmp1];
    % 计算降中峽相对高度 - 要求同时有降中峡与峰谷值
    tmp = features{1}*[0;1];
    tmp = tmp(indexes&pBoth,:);
    features{4} = [peaks(indexes&pBoth,1) tmp1./tmp];
    % 计算重博波高度 - 要求同时有重博波与谷值
    tmp2 = dicPeaks(indexes&pValleys,2) - valleys(indexes&pValleys,2);
    features{5}  = [peaks(indexes&pValleys,1) tmp2];
    % 计算重博波相对高度 - 要求同时有重博波与峰谷值
    features{6} =  [peaks(indexes&pBoth,1) tmp2./tmp];    
    
    % 计算K3 - 同时有重搏波与峰谷值
%     features(13) =  [peaks(indexesEndWith0,1) (dicPeaks(:,2)-valleys([0;indexesEndWith0(1:N-1)],2))...
%       ./(valleys([0;indexesEndWith0(1:N-1)],1) - dicPeaks(:,1))];
    if indexes(end) <= 0 %最后一个波形没有重博波
          features{13} =  [peaks(indexes&pBoth,1) (dicPeaks(indexes&pBoth,2)...
                -valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),2))...
                    ./(valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),1) - dicPeaks(indexes&pBoth,1))];
    else        
        features{13} =  [peaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),1) (dicPeaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),2)...
            -valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),2))./(valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),1)...
            - dicPeaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),1))];
    end
    
    % 计算降中峡~重搏波传播时间 - 要求同时有降中峡与重搏波
    features{26} = [peaks(indexes) dicPeaks(indexes,1) - dicNotchs(indexes,1)];
else
    features{3}=[];
    features{4}=[];
    features{5}=[];
    features{6}=[];
    
%     features{9}=[];
%     features{10}=[];
    
    features{13}=[];
    
    features{26}=[];
    
%     features{30}=[];
%     features{31}=[];
%     features{32}=[];
end


%% 
j=1;
k=1;
m=1;
n=1;
features{7} = peaks(1:N-1,:)*[1,0;0,0];
features{7}(:,2)=features{7}(:,2)+NaN;
features{8} = features{7};
features{34} = features{8};
features{35} = features{8};

features{9} = peaks(indexesEndWith0,:)*[1,0;0,0];
features{9}(:,2)=features{9}(:,2)+NaN;
features{10} = features{9};
for i=30:33
    features{i} = features{9};
end
for i=14:25
    features{i} = features{7};
end
for i=27:29   
    features{i} = features{7};
end
% save the sum of each pulse wave
tmp3 = zeros(N-1,1);

for i=1:N-1
   % The Sum
   if valleys(i,1)>0 && valleys(i+1,1)>0 &&(valleys(i+1,1) - valleys(i,1)<=threshold)
       tmp3(i) = sum(pw(valleys(i,1):valleys(i+1,1)));
       % 计算脉搏波面积 - 两个相邻的波谷均被检出
       features{7}(i,2) = calcArea(pw(valleys(i,1):valleys(i+1,1)) - minPW);
       % 计算其它相对面积 - 只有在正确检出相邻波谷的情况下才能检出
       % 计算升支相对面积 - 只有在正确检出相邻波谷间波峰的情况下才能检出
       if peaks(i)>0           
            features{8}(i,2) = calcArea(pw(valleys(i,1):peaks(i,1)) - minPW) / features{7}(i,2) ;
       end
       if dicNotchs(i,1) > 0 
            %计算与降中峽相关的两个相对面积
            features{9}(j,2) = calcArea(pw(peaks(i,1):dicNotchs(i,1)) - minPW) / features{7}(i,2) ;
            features{10}(j,2) = calcArea(pw(dicNotchs(i,1):valleys(i+1,1)) - minPW) / features{7}(i,2) ;
            
       end
   end
   
   if valleys(i,1)&&peaks(i,1)>0 && peaks(i+1,1)>0 &&(peaks(i+1,1) - peaks(i,1)<=pThreshold)
       %校正后的LVET
        features{34}(j,2) = dicNotchs(i,1) - valleys(i,1) + 1000*60*1.7/(peaks(i+1,1) - peaks(i,1));
        %脉率
        features{35}(j,2) = 60000/(peaks(i+1,1) - peaks(i,1));
        j=j+1;
   end
    
    if dicNotchs(i,1) > 0         
       if valleys(i,1)>0 &&valleys(i+1,1)>0 && peaks(i,1)>0&&(valleys(i+1,1) - valleys(i,1)<=threshold)
           % 计算G
            features{30}(m,2) = (valleys(i+1,1) - dicNotchs(i,1))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1))...
                - pw(dicNotchs(i,1));
            
           % 计算LeBA
           tmp =(valleys(i+1,1) - (peaks(i,1):valleys(i+1,1)))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1));
           tmp = tmp(:)  - pw(peaks(i,1):valleys(i+1,1));
           features{31}(m,2) = sqrt(tmp(:)'*tmp(:)/length(tmp));
           m=m+1;
       end
       % 计算TmCpt 与 TmpctR - 只有在两相邻谷值都存在且中间没有漏检的波形时才会计算
       if valleys(i,1)>0 && valleys(i+1,1)>0&&(valleys(i+1,1) - valleys(i,1)<=threshold)
           tmp = pw(dicNotchs(i,1):valleys(i+1,1)) - pw(dicNotchs(i,1));
           features{32}(n,2) = sum(tmp>0);
           features{33}(n,2) = features{32}(n,2)/(valleys(i+1,1) - valleys(i,1));           
            n = n+1;
       end
    end
    
    % 计算各相对高度点到波峰的时间
    if valleys(i,1)>0 && peaks(i,1)>0
        features{14}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.1);
        features{15}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.25);
        features{16}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.33);
        features{17}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.50);
        features{18}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.66);
        features{19}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.75);    
    end
    if valleys(i,1)>0 && valleys(i+1,1)>0 && peaks(i,1)>0&&(valleys(i+1,1) - valleys(i,1)<=threshold)
       features{20}(i,2) = valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.1);   
       features{21}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.25);
       features{22}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.33);
       features{23}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.50);
       features{24}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.66);
       features{25}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.75);     
    end
   if peaks(i)>0
       % 计算AmBE 
       features{28}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+100));

       % 计算DfAmBE ??? 可以直接用BE斜率替代吧
       features{29}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+1:peaks(i,1)+100));
   end
end

%% 计算K1
features{11}=[peaks(pBoth,1) (peaks(pBoth,2) - valleys(pBoth,2))./(peaks(pBoth,1) - valleys(pBoth,1))] ;

%% 计算K2
pbothpeaks=peaks(pBoth,:);
pbothvalleys=valleys(pBoth,:);
features{12}=[pbothpeaks((1:end-1),1) (pbothpeaks((1:end-1),2) - pbothvalleys((2:end),2))./...
    (pbothpeaks((1:end-1),1) - pbothvalleys(2:end,1))] ;

%% 计算K值
%连续两个valleys均检到对应的位置
pBiValleys=tmp3>0;
features{27}(:,2)= (tmp3./diff(valleys(:,1))-valleys(1:end-1,2))./features{1}(1:end-1,2);
features{27} = features{27}(pBoth(1:end-1)&pBiValleys,:);


%%筛选计算出的特征值序列
features{1}=features{1}(pBoth,:);
for i=7:10    
    if ~isempty(features{i})
        features{i} = features{i}((features{i}(:,1)>0)&~isnan(features{i}(:,2)),:);
    end
end
for i=14:35
    if ~isempty(features{i})
            features{i} = features{i}((features{i}(:,1)>0)&~isnan(features{i}(:,2)),:);
    end
end
