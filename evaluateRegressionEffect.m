function [errors] = evaluateRegressionEffect(y,coefs,x)
%evaluateRegressionEffect��������k�����ϵ������k���������ݵ����Ч����Ĭ���������Ϊ��Щϵ�������������ϵ����
%OUTPUT
%errors 1*k ����coefs���������õ���k��ƽ����� 
%INPUT
%y    n*1����    n��������ֵ
%coefs    1*m    ά��Ϊm�����ϵ��
%x    n*m����    n��ά��Ϊm������

%Ԥ��������
y = y(:);
figure
plot(y)
y = y * ones(1,length(coefs(:,1)));

%�����������
outputs = [ones(length(x(:,1)),1),x] * coefs';

%����������
errors = abs(outputs - y);

%���㷵��ֵ
errors = mean(errors);

%��ͼ
set(0,'DefaultFigureVisible','on');
figure
plot(outputs(:,1),'ko-'),
hold on,
plot(y(:,1),'ro-');
title(strcat('red:source BP blue:regression BP. r=',num2str(corr(outputs(:,1),y))));
set(0,'DefaultFigureVisible','off');