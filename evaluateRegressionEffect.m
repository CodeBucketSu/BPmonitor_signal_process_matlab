function [errors] = evaluateRegressionEffect(y,coefs,x)
%evaluateRegressionEffect��������k�����ϵ����Ч����Ĭ���������Ϊ��Щϵ�������������ϵ����
%OUTPUT
%errors 1*k ����coefs���������õ���k��ƽ����� 
%INPUT
%y    n*1����    n��������ֵ
%coefs    k*m����    k��ά��Ϊm�����ϵ��
%x    n*m����    n��ά��Ϊm������

%Ԥ��������
y = y(:);
figure
plot(y)
y = y * ones(1,length(coefs(:,1)));

%�����������
outputs = x * coefs';

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