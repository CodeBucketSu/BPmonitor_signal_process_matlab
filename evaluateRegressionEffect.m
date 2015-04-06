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
y = y * ones(1,length(coefs(:,1)));

%�����������
outputs = x * coefs';

%����������
outputs = abs(outputs - y);

%���㷵��ֵ
errors = mean(outputs);
