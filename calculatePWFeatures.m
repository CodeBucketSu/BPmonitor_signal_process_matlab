function [features,featureNames] = calculatePWFeatures(pw,peaks,valleys,dicNotchs,dicPeaks)
%������������������
%���룺
%   pw:�������ź� N*1
%   peaks,valleys,dicNotchs,dicPeaks:����/����/���Ѝ{/�ز�����λ��-�ź�ֵ����
%   Ҫ��peaks��valleys�ĳ�����ͬ
%���:
%   features,featureNames:����/������Ԫ������ K*2 [��ֵλ��,����ֵ]
%�����������������京��
%     PEAK-HEiGHT	�����߶�
%     PEAK-RiSE-TiME	��������ʱ�䣨����ʱ�䣩
%     DiCNOTCH-HEiGHT	���Ѝ{�߶�
%     DiCNOTCH-RELATiVE-HEiGHT	���Ѝ{��Ը߶�
%     DiCPEAK-HEiGHT	�ز����߶�
%     DiCPEAK-RELATiVE-HEiGHT	�ز�����Ը߶ȣ�����ϵ����
%     PULSE-WAVE-AREA	���������
%     RiSE-RELATiVE-AREA	��֧������
%     DiCEND-RELATiVE-AREA	B-C������
%     DiASTOLiC-RELATiVE-AREA	������������
%     K1	A-Bб��
%     K2	B-A��б��
%     K3	D-A��б��
%     SW10��SW25��	SWk
%     DW10��DW25��	DWk
%     AmBE	AmBE
%     DfAmBE DfAmBE
%     G	G
%     LeBA	LeBA
%     TmCpt	TmCpt

%% ��ʼ��
featureNames = {'PEAK-HEiGHT','PEAK-RiSE-TiME','DiCNOTCH-HEiGHT','DiCNOTCH-RELATiVE-HEiGHT','DiCPEAK-HEiGHT',...
'DiCPEAK-RELATiVE-HEiGHT','PULSE-WAVE-AREA','RiSE-RELATiVE-AREA','DiCEND-RELATiVE-AREA','DiASTOLiC-RELATiVE-AREA',...
'K1','K2','K3','SW10','SW25','SW33','SW50','SW66','SW75','DW10','DW25','DW33','DW50','DW66','DW75','AmBE','DfAmBE','G','LeBA','TmCpt'...
};
features = featureNames;
N = length(peaks(:,1));

dicNotchs = dicNotchs(1:N,:);
dicPeaks = dicPeaks(1:N,:);

indexes = dicNotchs(:,1)~=-1;
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

%% ���������߶�
features{1} = peaks - valleys(:,2)*[0,1];

%% ��������ʱ��
features{2} = peaks(:,1)*[1,1] - valleys(:,1)*[0,1];

%%
if calcNotch>0
    %���㽵�Ѝ{�߶�
    tmp1 = dicNotchs(indexes,2) - valleys(indexes,2);
    features{3} = [peaks(indexes,1) tmp1];
    % ���㽵�Ѝ{��Ը߶�
    tmp = features{1}*[0;1];
    tmp = tmp(indexes);
    features{4} = [peaks(indexes,1) tmp1./tmp];
    % �����ز����߶�
    tmp2 = dicPeaks(indexes,2) - valleys(indexes,2);
    features{5}  = [peaks(indexes,1) tmp2];
    % �����ز�����Ը߶�
    features{6} =  [peaks(indexes,1) tmp2./tmp];    
    
    % ����K3
%     features(13) =  [peaks(indexesEndWith0,1) (dicPeaks(:,2)-valleys([0;indexesEndWith0(1:N-1)],2))...
%       ./(valleys([0;indexesEndWith0(1:N-1)],1) - dicPeaks(:,1))];
    if dicPeaks(N,1) == -1 %���һ������û���ز���
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
   % �������������
   features{7}(i,2) = calcArea(pw(valleys(i,1):valleys(i+1,1)) - minPW);
    % ������֧������
    features{8}(i,2) = calcArea(pw(valleys(i,1):peaks(i,1)) - minPW) / features{7}(i,2) ;
    if dicNotchs(i,1) ~= -1 
        %�����뽵�Ѝ{��ص�����������
        features{9}(j,2) = calcArea(pw(peaks(i,1):dicNotchs(i,1)) - minPW) / features{7}(i,2) ;
        features{10}(j,2) = calcArea(pw(dicNotchs(i,1):valleys(i+1,1)) - minPW) / features{7}(i,2) ;
        
       % ����G
        features{28}(j,2) = (valleys(i+1,1) - dicNotchs(i,1))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1))...
            - pw(dicNotchs(i,1));
       % ����LeBA
       tmp =(valleys(i+1,1) - (peaks(i,1):valleys(i+1,1)))*pw(peaks(i,1))/(valleys(i+1,1) - peaks(i,1));
       tmp = tmp(:)  - pw(peaks(i,1):valleys(i+1,1));
       features{29}(j,2) = sqrt(tmp(:)'*tmp(:)/length(tmp));
       % ����TmCpt
       tmp = pw(dicNotchs(i,1):dicNotchs(i,1)+160) - pw(dicNotchs(i,1));
       features{30}(j,2) = sum(tmp>0);
        j = j+1;
    end
    
    % �������Ը߶ȵ㵽�����ʱ��
    
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
   
   % ����AmBE 
   features{26}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+100));
   
   % ����DfAmBE ??? ����ֱ����BEб�������
   features{27}(i,2) = mean(pw(peaks(i,1):peaks(i,1)+99) - pw(peaks(i,1)+1:peaks(i,1)+100));
end

%% ����K1
features{11}=[peaks(:,1) (peaks(:,2) - valleys(:,2))./(peaks(:,1) - valleys(:,1))] ;

%% ����K2
features{12}=[peaks(1:N-1,1) (peaks(1:N-1,2) - valleys(2:N,2))./...
    (peaks(1:N-1,1) - valleys(2:N,1))] ;

