function [features,featureNames] = calculatePWFeatures(pw,peaks,valleys,dicNotchs,dicPeaks)
%计算逐拍脉搏波特征
%输入：
%   pw:脉搏波信号 N*1
%   peaks,valleys,dicNotchs,dicPeaks:波峰/波谷/降中峽/重博波的位置-信号值序列
%   要求peaks与valleys的长度相同
%输出:
%   features,featureNames:特征/特征名元胞数组 K*2 [峰值位置,特征值]
%各种逐拍特征名及其含义
%     PEAK-HEiGHT	主波高度
%     PEAK-RiSE-TiME	主波上升时间（流出时间）
%     DiCNOTCH-HEiGHT	降中峽高度
%     DiCNOTCH-RELATiVE-HEiGHT	降中峽相对高度
%     DiCPEAK-HEiGHT	重博波高度
%     DiCPEAK-RELATiVE-HEiGHT	重博波相对高度（反射系数）
%     PULSE-WAVE-AREA	脉搏波面积
%     RiSE-RELATiVE-AREA	升支相对面积
%     DiCEND-RELATiVE-AREA	B-C相对面积
%     DiASTOLiC-RELATiVE-AREA	舒张期相对面积
%     K1	A-B斜率
%     K2	B-A’斜率
%     K3	D-A’斜率
%     SW10、SW25…	SWk
%     DW10、DW25…	DWk
%     AmBE	AmBE
%     DfAmBE DfAmBE
%     G	G
%     LeBA	LeBA
%     TmCpt	TmCpt

%% 初始化
featureNames = {'PEAK-HEiGHT','PEAK-RiSE-TiME','DiCNOTCH-HEiGHT','DiCNOTCH-RELATiVE-HEiGHT','DiCPEAK-HEiGHT',...
'DiCPEAK-RELATiVE-HEiGHT','PULSE-WAVE-AREA','RiSE-RELATiVE-AREA','DiCEND-RELATiVE-AREA','DiASTOLiC-RELATiVE-AREA',...
'K1','K2','K3','SW10','SW25','SW33','SW50','SW66','SW75','DW10','DW25','DW33','DW50','DW66','DW75','AmBE','DfAmBE','G','LeBA','TmCpt'...
};
features = featureNames;
N = length(peaks(:,1));

dicNotchs = dicNotchs(1:N,:);
dicPeaks = dicPeaks(1:N,:);

indexes = dicNotchs(:,1)~=-1;
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

%% 计算主波高度
features{1} = peaks - valleys(:,2)*[0,1];

%% 计算上升时间
features{2} = peaks(:,1)*[1,1] - valleys(:,1)*[0,1];

%%
if calcNotch>0
    %计算降中峽高度
    tmp1 = dicNotchs(indexes,2) - valleys(indexes,2);
    features{3} = [peaks(indexes,1) tmp1];
    % 计算降中峽相对高度
    tmp = features{1}*[0;1];
    tmp = tmp(indexes);
    features{4} = [peaks(indexes,1) tmp1./tmp];
    % 计算重博波高度
    tmp2 = dicPeaks(indexes,2) - valleys(indexes,2);
    features{5}  = [peaks(indexes,1) tmp2];
    % 计算重博波相对高度
    features{6} =  [peaks(indexes,1) tmp2./tmp];    
    
    % 计算K3
%     features(13) =  [peaks(indexesEndWith0,1) (dicPeaks(:,2)-valleys([0;indexesEndWith0(1:N-1)],2))...
%       ./(valleys([0;indexesEndWith0(1:N-1)],1) - dicPeaks(:,1))];
    if dicPeaks(N,1) == -1 %最后一个波形没有重博波
          features{13} =  [peaks(indexes,1) (dicPeaks(:,2)-valleys(logical([0;indexes(1:N-1)]),2))...
              ./(valleys(logical([0;indexes(1:N-1)]),1) - dicPeaks(:,1))];
    else
        features{13} =  [peaks(logical([indexes(1:N-1);0]),1) (dicPeaks(1:N-1,2)-valleys(logical([0;indexes(1:N-1)]),2))...
              ./(valleys(logical([0;indexes(1:N-1)]),1) - dicPeaks(1:N-1,1))];
    end
else
    features{3}=[];
    features{4}=[];
    features{5}=[];
    features{6}=[];
    
    features{9}=[];
    features{10}=[];
    
    features{13}=[];
    
    features{28}=[];
    features{29}=[];
    features{30}=[];
end

%% 
j=1;
features{7} = peaks(1:N-1,:);
features{8} = features{7};
features{9} = peaks(indexesEndWith0,:);
features{10} = features{9};
features{28} = features{9};
features{29} = features{9};
features{30} = features{9};

for i=14:27
    features{i} = peaks(1:N-1,:);
end
for i=1:N-1
   % 计算脉搏波面积
   features{7}(i,2) = calcArea(pw(valleys(i,1):valleys(i+1,1)) - minPW);
    % 计算升支相对面积
    features{8}(i,2) = calcArea(pw(valleys(i,1):peaks(i,1)) - minPW) / features{7}(i,2) ;
    if dicNotchs(i,1) ~= -1 
        %计算与降中峽相关的两个相对面积
        features{9}(j,2) = calcArea(pw(peaks(i,1):dicNotchs(i,1)) - minPW) / features{7}(i,2) ;
        features{10}(j,2) = calcArea(pw(dicNotchs(i,1):valleys(i+1,1)) - minPW) / features{7}(i,2) ;
        
       % 计算G
        features{28}(j,2) = (valleys(i+1,1) - dicNotchs(i,1))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1))...
            - pw(dicNotchs(i,1));
       % 计算LeBA
       tmp =(valleys(i+1,1) - (peaks(i,1):valleys(i+1,1)))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1));
       tmp = tmp(:)  - pw(peaks(i,1):valleys(i+1,1));
       features{29}(j,2) = sqrt(tmp(:)'*tmp(:)/length(tmp));
       % 计算TmCpt
       tmp = pw(dicNotchs(i,1):dicNotchs(i,1)+160) - pw(dicNotchs(i,1));
       features{30}(j,2) = sum(tmp>0);
        j = j+1;
    end
    
    % 计算各相对高度点到波峰的时间
    
    features{14}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.1);
    features{15}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.25);
    features{16}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.33);
    features{17}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.50);
    features{18}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.66);
    features{19}(i,2) =peaks(i,1) - valleys(i,1)-detectKpercentKeyPoint(pw(valleys(i,1):peaks(i,1)),0.75);
    
   features{20}(i,2) = valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.1);   
   features{21}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.25);
   features{22}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.33);
   features{23}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.50);
   features{24}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.66);
   features{25}(i,2) =valleys(i+1,1) - peaks(i,1) - detectKpercentKeyPoint(pw(peaks(i,1):valleys(i+1,1)),0.75);  
   
   % 计算AmBE 
   features{26}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+100));
   
   % 计算DfAmBE ??? 可以直接用BE斜率替代吧
   features{27}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+1:peaks(i,1)+100));
end

%% 计算K1
features{11}=[peaks(:,1) (peaks(:,2) - valleys(:,2))./(peaks(:,1) - valleys(:,1))] ;

%% 计算K2
features{12}=[peaks(1:N-1,1) (peaks(1:N-1,2) - valleys(2:N,2))./...
    (peaks(1:N-1,1) - valleys(2:N,1))] ;

