function [errors] = evaluateRegressionEffect(y,coefs,x)
%evaluateRegressionEffect��������k�����ϵ������k�������������ݵĹ���Ч����Ĭ���������Ϊ��Щϵ�������������ϵ����
%OUTPUT
%errors 1*k ����coefs���������õ���k��ƽ����� 
%INPUT
%y    k*n����    k��ά��Ϊn��������ֵ
%coefs    k*m    k��ά��Ϊm�����ϵ��
%x    n*m����    n��ά��Ϊm������

%Ԥ����
errors = zeros(1,length(y(:,1)));
set(0,'DefaultFigureVisible','on');
figure
for i=1:length(y(:,1))
	%Ԥ����
	y0 = y(i,:)';

	%�����������
	outputs = [ones(length(x(:,1)),1),x] * coefs(i,:)';
	% only for wl
	%outputs = outputs([1:14, 17:20]);
	%y = y([1:14, 17:20]);

	%�������
	terror = abs(outputs - y0);

	%���㷵��ֵ
	errors(i) = mean(terror);

	%��ͼ
	subplot(length(y(:,1)),1,i);
	plot1 = plot(outputs(:,1),'ko-'),
	hold on,
	plot2 = plot(y0(:,1),'ro-');
	legend([plot1, plot2], {'BPest', 'BPreal'});
	title(['r=',num2str(corr(outputs(:,1),y0(:,1))),' err=:', num2str(errors(i))]);
	end


set(0,'DefaultFigureVisible','off');