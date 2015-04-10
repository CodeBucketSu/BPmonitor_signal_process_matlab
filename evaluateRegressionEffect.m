function [errors,corrs] = evaluateRegressionEffect(y,coefs,x,varargin)
%evaluateRegressionEffect��������k�飨����-���ϵ��-�������Ч����Ĭ���������Ϊ��Щϵ�������������ϵ����
%OUTPUT
%errors 1*k ����coefs���������õ���k��ƽ����� 
%corrs 1��k ����k��coefs���������õ���k�����ϵ��
%INPUT
%y    n*1����    n��������ֵ
%coefs    k*m����    k��ά��Ϊm�����ϵ��
%x    n*m����    n��ά��Ϊm������
%varargin
% {1} - savePath    string    ͼ��Ĵ洢·��
%Ԥ����
close all;
fileName = 'testsetResult';
%Ԥ��������
errors = zeros(1,length(y(:,1)));
corrs = zeros(1,length(y(:,1)));

%set(0,'DefaultFigureVisible','on');
fig = figure;
for i=1:length(y(:,1))
	%Ԥ��������
	y0 = y(i,:)';
	
	%�������
	outputs = [ones(length(x(:,1)),1),x] * coefs(i,:)';
	% only for wl
% 	outputs = outputs([1:14, 17:20]);
% 	y0 = y0([1:14, 17:20]);

	%�������
	terror = abs(outputs - y0);

	%���㷵��ֵ
	errors(i) = mean(terror);
	corrs(i) = corr(outputs(:,1),y0(:,1));

	%��ͼ
	subplot(length(y(:,1)),1,i);
	plot1 = plot(outputs(:,1),'ko-');
	hold on,
	plot2 = plot(y0(:,1),'ro-');
	legend([plot1, plot2], {'BPest', 'BPreal'});
	title(['r=',num2str(corrs(i)),' err=:', num2str(errors(i))]);
	end

	% ���������ͼ��洢·�����򱣴��ͼ���ļ�
	if nargin==4
    	saveFigure(fig,varargin{1},fileName);
    elseif nargin==5
	    saveFigure(fig,varargin{1},varargin{2});    
	end

%set(0,'DefaultFigureVisible','off');