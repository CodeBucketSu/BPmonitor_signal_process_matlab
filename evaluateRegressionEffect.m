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
% only for wl
outputs = outputs([1:14, 17:20]);
y = y([1:14, 17:20]);

%����������
errors = abs(outputs - y);

%���㷵��ֵ
errors = mean(errors);

%��ͼ
set(0,'DefaultFigureVisible','on');
figure
plot1 = plot(outputs(:,1),'ko-'),
hold on,
plot2 = plot(y(:,1),'ro-');
legend([plot1, plot2], {'BPest', 'BPreal'});
title(['r=',num2str(corr(outputs(:,1),y)),' err=:', num2str(errors)]);
set(0,'DefaultFigureVisible','off');