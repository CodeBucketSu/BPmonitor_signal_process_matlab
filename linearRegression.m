function [coefs,errors]...
    =linearRegression(BPs,features,varargin)
%linearRegression�������ڼ����Ԫ�������ƽ��ѹ������ѹ������ѹ�����ϵ��
%��Ϲ�ʽΪ bp = a*pwtt + b*k +c*prt+d*...
%OUTPUT
%coefs    k*m����   [[a_mbp,b_mbp,c_mbp,...];[a_dbp,b_dbp,c_dbp,...];...]
%   ��Ӧ��k��BP�����ϵ�����С������ܹ���3��BP,���kС�ڵ���3.m��Ӧ��m������
%errors    k*1����    ��Ӧ��k��BP�Ĳв����С�errorֵԽ��˵�����Ч��Խ��

%INPUT
%BPs    k*n����    [[mbp_1,mbp_2,...mbp_n];[dbp_1,dbp_2,...dbp_n];...]n�β����õ���k��BP����
%features    n*m����
%   [[pwtt_1,pwtt_2,...pwtt_n]',[k_1,k_2,...k_n]',[prt_1,prt_2,...prt_n]...]
%    n�β����õ���m���������С�ÿ������ֻ��nά��ԭ���Ƕ�ÿ���������ԣ���ÿ��Ѫѹ���������в����p��ֵ��Ȼ�����p��ֵ���ֵ�õ�n��ƽ��ֵ���ֱ��Ӧ��ÿ�β���
%varargin
% {1} - savePath    string    ͼ��Ĵ洢·��
close all;
%Ԥ����
fileName = '0-trainset';
%���䷵��ֵ�ռ�
coefs = zeros(length(BPs(:,1)), length(features(1,:)) + 1);
errors=zeros(length(BPs(:,1)), 1);
%������
for i=1:length(BPs(:,1))
    [coef,~,error] = regress(BPs(i,:)',[ones(length(features(:,1)),1),features]);
    coefs(i,:) = coef';
    errors(i) = mean(abs(error));
end
%��������
%n*k����n����ϵõ���k��Ѫѹֵ
BPRegression = [ones(length(features(:,1)),1),features]*coefs';
%set(0,'DefaultFigureVisible','on');
fig = figure;
for i=1:length(BPs(:,1))
	subplot(length(BPs(:,1)),1,i)
	plot2 = plot(BPs(i,:),'ro-');
	hold on
	plot1 = plot(BPRegression(:,i),'ko-');
    legend([plot1, plot2], {'BPest', 'BPreal'});
    ttl = {[' r=',num2str(corr(BPs(i,:)',BPRegression(:,i))), ' err=', num2str(errors(i))]};
    strCoefs = '';
    for r = 1:size(coefs, 2)
        strCoefs = [strCoefs, num2str(coefs(i, r)), ','];
    end
    ttl{end + 1} = strCoefs;
    title(ttl);
end
% ���������ͼ��洢·�����򱣴��ͼ���ļ�
if nargin==3
    saveFigure(fig,varargin{1},fileName);    
elseif nargin==4
    saveFigure(fig,varargin{1},varargin{2});    
end
%set(0,'DefaultFigureVisible','off');
