function [coefs,errors]...
    =linearRegression(BPs,features)
%linearRegression�������ڼ����Ԫ�������ƽ��ѹ������ѹ������ѹ�����ϵ��
%��Ϲ�ʽΪ bp = a*pwtt + b*k +c*prt+d*...
%OUTPUT
%coefs    k*m����   [[a_mbp,b_mbp,c_mbp,...];[a_dbp,b_dbp,c_dbp,...];...]
%   ��Ӧ��k��BP�����ϵ�����С������ܹ���3��BP,���kС�ڵ���3.m��Ӧ��m������
%errors    k*1����  ��Ӧ��k��BP�Ĳв����С�errorֵԽ��˵�����Ч��Խ��
%INPUT
%BPs    k*n����    [[mbp_1,mbp_2,...mbp_n];[dbp_1,dbp_2,...dbp_n];...]n�β����õ���k��BP����
%features    n*m����
%   [[pwtt_1,pwtt_2,...pwtt_n]',[k_1,k_2,...k_n]',[prt_1,prt_2,...prt_n]...]
%    n�β����õ���m���������С�ÿ������ֻ��nά��ԭ���Ƕ�ÿ���������ԣ���ÿ��Ѫѹ���������в����p��ֵ��Ȼ�����p��ֵ���ֵ�õ�n��ƽ��ֵ���ֱ��Ӧ��ÿ�β���

%���䷵��ֵ�ռ�
coefs = zeros(length(BPs(:,1)), length(features(1,:)));
errors=zeros(length(BPs(:,1)), 1);
%������
for i=1:length(BPs(:,1))
    [coef,~,error] = regress(BPs(i,:)',features);
    coefs(i,:) = coef';
    errors(i) = mean(abs(error));
end
