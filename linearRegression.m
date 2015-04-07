function [coefs,errors]...
    =linearRegression(BPs,features)
%linearRegression函数用于计算多元线性拟合平均压，收缩压与舒张压的拟合系数
%拟合公式为 bp = a*pwtt + b*k +c*prt+d*...
%OUTPUT
%coefs    k*m矩阵   [[a_mbp,b_mbp,c_mbp,...];[a_dbp,b_dbp,c_dbp,...];...]
%   对应于k种BP的拟合系数序列。由于总共有3种BP,因此k小于等于3.m对应于m种特征
%errors    k*1矩阵  对应于k种BP的残差序列。error值越大，说明拟合效果越差
%INPUT
%BPs    k*n矩阵    [[mbp_1,mbp_2,...mbp_n];[dbp_1,dbp_2,...dbp_n];...]n次测量得到的k种BP序列
%features    n*m矩阵
%   [[pwtt_1,pwtt_2,...pwtt_n]',[k_1,k_2,...k_n]',[prt_1,prt_2,...prt_n]...]
%    n次测量得到的m种特征序列。每种特征只有n维的原因是对每种特征而言，在每次血压测量过程中测得了p个值，然后对这p个值求均值得到n个平均值，分别对应于每次测量

%分配返回值空间
coefs = zeros(length(BPs(:,1)), length(features(1,:)));
errors=zeros(length(BPs(:,1)), 1);
%完成拟合
for i=1:length(BPs(:,1))
    [coef,~,error] = regress(BPs(i,:)',features);
    coefs(i,:) = coef';
    errors(i) = mean(abs(error));
end
