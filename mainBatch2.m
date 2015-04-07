%%预定义:
%采取的特征点检测方式
method = 'PEAK';
save('method.mat','method');

set(0,'DefaultFigureVisible','off');
needPlot = 0;

%选择标定数据集所在的文件夹s
disp '请选择标定数据集所在的文件夹s';
paths = uipickfiles('REFilter','\$','FilterSpec','L:\young\syl');
if isempty(path)
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);
[coefs,errors] = linearRegression(BPs,PWFs');
disp '请选择测试数据集所在的文件夹s';
paths = uipickfiles('REFilter','\$');
if isempty(path)
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);
%% 评估效果
regressionErrors = zeros(length(BPs(:,1)),1);
%%对每种血压生成误差
for i=1:length(BPs(:,1))
    regressionErrors(i) = evaluateRegressionEffect(BPs(i,:),coefs(i,:),PWFs');
end

save('errors.mat','regressionErrors');
%