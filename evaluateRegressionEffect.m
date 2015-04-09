function [errors] = evaluateRegressionEffect(y,coefs,x,varargin)
%evaluateRegressionEffect用于评估k组拟合系数的效果。默认情况下认为这些系数都是线性拟合系数。
%OUTPUT
%errors 1*k 对于coefs进行评估得到的k个平均误差 
%INPUT
%y    n*1矩阵    n组输出结果值
%coefs    k*m矩阵    k组维数为m的拟合系数
%x    n*m矩阵    n组维数为m的输入
%varargin
% {1} - savePath    string    图像的存储路径
%预定义
fileName = 'testsetResult';
%预处理输入
errors = zeros(1,length(y(:,1)));
%set(0,'DefaultFigureVisible','on');
fig = figure;
for i=1:length(y(:,1))
	%预处理输入
	y0 = y(i,:)';
	
	%计算输出
	outputs = [ones(length(x(:,1)),1),x] * coefs(i,:)';
	% only for wl
	%outputs = outputs([1:14, 17:20]);
	%y = y([1:14, 17:20]);

	%计算误差
	terror = abs(outputs - y0);

	%计算返回值
	errors(i) = mean(terror);

	%绘图
	subplot(length(y(:,1)),1,i);
	plot1 = plot(outputs(:,1),'ko-');
	hold on,
	plot2 = plot(y0(:,1),'ro-');
	legend([plot1, plot2], {'BPest', 'BPreal'});
	title(['r=',num2str(corr(outputs(:,1),y0(:,1))),' err=:', num2str(errors(i))]);
	end

	% 如果传入了图像存储路径，则保存截图到文件
	if nargin==4
    	saveFigure(fig,varargin{1},fileName);
    elseif nargin==5
	    saveFigure(fig,varargin{1},varargin{2});    
	end

%set(0,'DefaultFigureVisible','off');