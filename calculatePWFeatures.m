function [features,featureNames] = calculatePWFeatures(pw,peaks,valleys,dicNotchs,dicPeaks)
%������������������
%�趨:peaks��valleys��һά��һ����ͬʱΪ-1,��dicNotchs��dicPeaks��һάһ����ͬʱΪ-1
%�༴һ����ͬʱ��⵽����Ͽ���ز���,����һ����ͬʱ��⵽�����벨��
%���룺
%   pw:�������ź� N*1
%   peaks,valleys,dicNotchs,dicPeaks:[P*2]����/����/���Ѝ{/�ز�����λ��-�ź�ֵ����
%   Ҫ���ĸ��źŵĳ��ȱ�����ͬ
%���:
%   features,featureNames:����/������Ԫ������ K*2 [��ֵλ��,����ֵ]
%�����������������京����ĵ�

%% ��ʼ��35��������
featureNames = {'PH','PRT','DNH','DNHr','DPH','DPHr','PWA','RBAr','DBAr','DiaAr',...
'SLP1','SLP2','SLP3','RBW10','RBW25','RBW33','RBW50','RBW66','RBW75','DBW10','DBW25','DBW33','DBW50','DBW66','DBW75',...
'DNPT','KVAL','AmBE','DfAmBE','DNC','SC','DPW','DPWr','PDNT','PDPT'...
};
%% ��ʼ��ÿ������
features = featureNames;
for i=1:length(featureNames)
    features{i} = [-1,0];
end
%��4������ĳ��ȱ��붼ΪN - �������
N = length(peaks(:,1));
if N<2
    return
end
if length(dicPeaks(:,1))~=N ||length(dicNotchs(:,1))~=N || length(valleys(:,1))~=N
    error('����������������');
end
%�洢�����ֵ���ε�λ��
pPeaks=peaks(:,1)>0;
%�洢�����ֵ���ε�λ��
pValleys=valleys(:,1)>0;
%�洢ͬʱ������ֵ���ε�λ��
pBoth=pPeaks&pValleys;
%���ȼ����-��ֵ��ֵ
valley2valleyDists=valleys(pValleys,1);
valley2valleyDists=valley2valleyDists(2:end) - valley2valleyDists(1:end-1);
threshold=median(valley2valleyDists)*1.5;
%���ȼ����-��ֵ��ֵ
peak2peakDists=peaks(pPeaks,1);
peak2peakDists=peak2peakDists(2:end) - peak2peakDists(1:end-1);
pThreshold=median(peak2peakDists)*1.5;

%���Ѝ{/�ز���Ԥ����
dicNotchs = dicNotchs(1:N,:);
dicPeaks = dicPeaks(1:N,:);
if dicNotchs(1,1)>0 && dicNotchs(1,1)<valleys(1,1)% ˵����һ�������н��Ѝ{��û�в���
    dicNotchs(1,1) = -1;
    dicPeaks(1,1) = -1;
end

%�洢�������Ͽ/�ز�����λ��
indexes = dicNotchs(:,1) > 0;
%��indexes���һ�����������γɵ����飬���ڱ��������Ҫ���ȵĲ���ʱԽ��
indexesEndWith0 = indexes;
indexesEndWith0(end) = 0;
%notchLen = sum(indexes);
minPW = min(pw);

%% �ж���������Ƿ��ܹ����ڼ��㽵�Ѝ{�������
calcNotch = 1;
if length(dicNotchs)<3
    calcNotch=0;
end

%% ���������߶� - Ҫ��ͬʱ�з��ֵ
features{1} = peaks- valleys(:,2)*[0,1];

%% ��������ʱ�� - Ҫ��ͬʱ�з��ֵ
features{2} = peaks(pBoth,1)*[1,1] - valleys(pBoth,1)*[0,1];

%%
if calcNotch>0
%     %���㲨��������Ͽ����ʱ�� - Ҫ��ͬʱ�н���Ͽ���ֵ
%     tmp1 = dicNotchs(indexes&pValleys,1) - valleys(indexes&pValleys,1);
%     features{34} = [peaks(indexes&pValleys,1) tmp1];
    %���㲨�����ز�������ʱ�� - Ҫ��ͬʱ���ز������ֵ    
%     tmp1 = dicPeaks(indexes&pValleys,1) - valleys(indexes&pValleys,1);
%     features{35} = [peaks(indexes&pValleys,1) tmp1];
    %���㽵�Ѝ{�߶� - Ҫ��ͬʱ�н���Ͽ���ֵ
    tmp1 = dicNotchs(indexes&pValleys,2) - valleys(indexes&pValleys,2);
    features{3} = [peaks(indexes&pValleys,1) tmp1];
    % ���㽵�Ѝ{��Ը߶� - Ҫ��ͬʱ�н���Ͽ����ֵ
    tmp = features{1}*[0;1];
    tmp = tmp(indexes&pBoth,:);
    features{4} = [peaks(indexes&pBoth,1) tmp1./tmp];
    % �����ز����߶� - Ҫ��ͬʱ���ز������ֵ
    tmp2 = dicPeaks(indexes&pValleys,2) - valleys(indexes&pValleys,2);
    features{5}  = [peaks(indexes&pValleys,1) tmp2];
    % �����ز�����Ը߶� - Ҫ��ͬʱ���ز�������ֵ
    features{6} =  [peaks(indexes&pBoth,1) tmp2./tmp];    
    
    % ����K3 - ͬʱ���ز�������ֵ
%     features(13) =  [peaks(indexesEndWith0,1) (dicPeaks(:,2)-valleys([0;indexesEndWith0(1:N-1)],2))...
%       ./(valleys([0;indexesEndWith0(1:N-1)],1) - dicPeaks(:,1))];
    if indexes(end) <= 0 %���һ������û���ز���
          features{13} =  [peaks(indexes&pBoth,1) (dicPeaks(indexes&pBoth,2)...
                -valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),2))...
                    ./(valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),1) - dicPeaks(indexes&pBoth,1))];
    else        
        features{13} =  [peaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),1) (dicPeaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),2)...
            -valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),2))./(valleys(logical([0;indexes(1:N-1)&pBoth(1:N-1)]),1)...
            - dicPeaks(logical([indexes(1:N-1)&pBoth(1:N-1);0]),1))];
    end
    
    % ���㽵��Ͽ~�ز�������ʱ�� - Ҫ��ͬʱ�н���Ͽ���ز���
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
       % ������������� - �������ڵĲ��Ⱦ������
       features{7}(i,2) = calcArea(pw(valleys(i,1):valleys(i+1,1)) - minPW);
       % �������������� - ֻ������ȷ������ڲ��ȵ�����²��ܼ��
       % ������֧������ - ֻ������ȷ������ڲ��ȼ䲨�������²��ܼ��
       if peaks(i)>0           
            features{8}(i,2) = calcArea(pw(valleys(i,1):peaks(i,1)) - minPW) / features{7}(i,2) ;
       end
       if dicNotchs(i,1) > 0 
            %�����뽵�Ѝ{��ص�����������
            features{9}(j,2) = calcArea(pw(peaks(i,1):dicNotchs(i,1)) - minPW) / features{7}(i,2) ;
            features{10}(j,2) = calcArea(pw(dicNotchs(i,1):valleys(i+1,1)) - minPW) / features{7}(i,2) ;
            
       end
   end
   
   if valleys(i,1)&&peaks(i,1)>0 && peaks(i+1,1)>0 &&(peaks(i+1,1) - peaks(i,1)<=pThreshold)
       %У�����LVET
        features{34}(j,2) = dicNotchs(i,1) - valleys(i,1) + 1000*60*1.7/(peaks(i+1,1) - peaks(i,1));
        %����
        features{35}(j,2) = 60000/(peaks(i+1,1) - peaks(i,1));
        j=j+1;
   end
    
    if dicNotchs(i,1) > 0         
       if valleys(i,1)>0 &&valleys(i+1,1)>0 && peaks(i,1)>0&&(valleys(i+1,1) - valleys(i,1)<=threshold)
           % ����G
            features{30}(m,2) = (valleys(i+1,1) - dicNotchs(i,1))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1))...
                - pw(dicNotchs(i,1));
            
           % ����LeBA
           tmp =(valleys(i+1,1) - (peaks(i,1):valleys(i+1,1)))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1));
           tmp = tmp(:)  - pw(peaks(i,1):valleys(i+1,1));
           features{31}(m,2) = sqrt(tmp(:)'*tmp(:)/length(tmp));
           m=m+1;
       end
       % ����TmCpt �� TmpctR - ֻ���������ڹ�ֵ���������м�û��©��Ĳ���ʱ�Ż����
       if valleys(i,1)>0 && valleys(i+1,1)>0&&(valleys(i+1,1) - valleys(i,1)<=threshold)
           tmp = pw(dicNotchs(i,1):valleys(i+1,1)) - pw(dicNotchs(i,1));
           features{32}(n,2) = sum(tmp>0);
           features{33}(n,2) = features{32}(n,2)/(valleys(i+1,1) - valleys(i,1));           
            n = n+1;
       end
    end
    
    % �������Ը߶ȵ㵽�����ʱ��
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
       % ����AmBE 
       features{28}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+100));

       % ����DfAmBE ??? ����ֱ����BEб�������
       features{29}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+1:peaks(i,1)+100));
   end
end

%% ����K1
features{11}=[peaks(pBoth,1) (peaks(pBoth,2) - valleys(pBoth,2))./(peaks(pBoth,1) - valleys(pBoth,1))] ;

%% ����K2
pbothpeaks=peaks(pBoth,:);
pbothvalleys=valleys(pBoth,:);
features{12}=[pbothpeaks((1:end-1),1) (pbothpeaks((1:end-1),2) - pbothvalleys((2:end),2))./...
    (pbothpeaks((1:end-1),1) - pbothvalleys(2:end,1))] ;

%% ����Kֵ
%��������valleys���쵽��Ӧ��λ��
pBiValleys=tmp3>0;
features{27}(:,2)= (tmp3./diff(valleys(:,1))-valleys(1:end-1,2))./features{1}(1:end-1,2);
features{27} = features{27}(pBoth(1:end-1)&pBiValleys,:);


%%ɸѡ�����������ֵ����
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
