% close all;
%%Ԥ����:
%��ȡ���������ⷽʽ
method = 'PEAK';
save('method.mat','method');

set(0,'DefaultFigureVisible','off');
needPlot = 0;

%ѡ��궨���ݼ����ڵ��ļ���s
disp '��ѡ��궨���ݼ����ڵ��ļ���s';
paths = uipickfiles('REFilter','\$','FilterSpec','E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\');

if isempty(path)
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);
[coefs,errors] = linearRegression(BPs,PWFs');
disp '��ѡ��������ݼ����ڵ��ļ���s';
paths = uipickfiles('REFilter','\$','FilterSpec','E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\');
if isempty(path)
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot);

%����Ч��
regressionErrors = evaluateRegressionEffect(BPs,coefs,PWFs');