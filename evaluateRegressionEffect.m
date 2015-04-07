function [errors] = evaluateRegressionEffect(y,coefs,x)
%evaluateRegressionEffect用于评估k组拟合系数对于k组待测试输出数据的估计效果。默认情况下认为这些系数都是线性拟合系数。
%OUTPUT
%errors 1*k 对于coefs进行评估得到的k个平均误差 
%INPUT
%y    k*n矩阵    k组维数为n的输出结果值
%coefs    k*m    k组维数为m的拟合系数
%x    n*m矩阵    n组维数为m的输入

%预定义
errors = zeros(1,length(y(:,1)));
set(0,'DefaultFigureVisible','on');
figure
for i=1:length(y(:,1))
	%预处理
	y0 = y(i,:)';

	%计算输出向量
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
	plot1 = plot(outputs(:,1),'ko-'),
	hold on,
	plot2 = plot(y0(:,1),'ro-');
	legend([plot1, plot2], {'BPest', 'BPreal'});
	title(['r=',num2str(corr(outputs(:,1),y0(:,1))),' err=:', num2str(errors(i))]);
	end


set(0,'DefaultFigureVisible','off');