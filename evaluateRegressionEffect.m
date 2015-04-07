function [errors] = evaluateRegressionEffect(y,coefs,x)
%evaluateRegressionEffect用于评估k组拟合系数对于k组待拟合数据的拟合效果。默认情况下认为这些系数都是线性拟合系数。
%OUTPUT
%errors 1*k 对于coefs进行评估得到的k个平均误差 
%INPUT
%y    n*1矩阵    n组输出结果值
%coefs    1*m    维数为m的拟合系数
%x    n*m矩阵    n组维数为m的输入

%预处理输入
y = y(:);
figure
plot(y)
y = y * ones(1,length(coefs(:,1)));

%计算输出矩阵
outputs = [ones(length(x(:,1)),1),x] * coefs';

%计算误差矩阵
errors = abs(outputs - y);

%计算返回值
errors = mean(errors);

%绘图
set(0,'DefaultFigureVisible','on');
figure
plot(outputs(:,1),'ko-'),
hold on,
plot(y(:,1),'ro-');
title(strcat('red:source BP blue:regression BP. r=',num2str(corr(outputs(:,1),y))));
set(0,'DefaultFigureVisible','off');