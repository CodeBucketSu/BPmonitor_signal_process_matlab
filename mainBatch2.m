%%Ԥ����:
%��ȡ���������ⷽʽ
method = 'PEAK';
save('method.mat','method');

set(0,'DefaultFigureVisible','off');
needPlot = 0;

%ѡ��궨���ݼ����ڵ��ļ���s
'��ѡ��궨���ݼ����ڵ��ļ���s'
paths = uipickfiles('REFilter','\$');
if length(paths) == 0
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);
[coefs,errors] = linearRegression(BPs,PWFs');
'��ѡ��������ݼ����ڵ��ļ���s'
paths = uipickfiles('REFilter','\$');
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);
%% ����Ч��
regressionErrors = [];
%%��ÿ��Ѫѹ�������
for i=1:length(BPs(:,1))
    regressionErrors(i) = evaluateRegressionEffect(BPs(i,:),coefs(i,:),PWFs');
end

save('errors.mat','regressionErrors');
%