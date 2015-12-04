close all

%%预定�?
%采取の特征点�?��方式
method = 'WAVELET';
save('method.mat','method');
%绘图の设�?
set(0,'DefaultFigureVisible','off');
needPlot = 1;
%存储图片の文件夹名称
name = 'MultiLinearRegression';
%说明文件の名�?
readme = 'readme.md';
%说明文件中训练集与测试集の标�?
setMarker = {'**trainset**','**testset**'};
%采取の脉搏波特征特征�?
selectedPWFNames = {'KVAL'};%'KVAL','PRT','DPW','DPWr','DiaAr'

disp '请�?择标定数据集�?��的文件夹s';
paths = uipickfiles('REFilter','\$','FilterSpec','L:\young');%'E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\'

if isempty(path)
    return
end

%%存储截图の路�?
parentPath = fileparts(paths{1});
[parentPath dataProvider] = fileparts(parentPath);
fullPath = fullfile(parentPath,name);
if ~exist(fullPath)
	mkdir(fullPath);
end
fullPath = fullfile(fullPath, ...
	[datestr(now, 'yyyy-mm-dd-HH-MM-SS') '-trainset from' dataProvider])
mkdir(fullPath);
%%写入说明文件：训练集部分
fid = fopen(fullfile(fullPath,readme),'w+');
if fid~=-1
	fprintf(fid,'%s\r\n',setMarker{1});
	for i=1:length(paths)
		[~,childPath]=fileparts(paths{i});
		fprintf(fid,'%d. %s\r\n',i,[dataProvider,'-',childPath])
	end
end

[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot,selectedPWFNames);
[coefs,errors] = linearRegression(BPs,PWFs',fullPath);

disp '请�?择测试数据集�?��的文件夹s';
paths = uipickfiles('REFilter','\$','FilterSpec',fileparts(paths{1}));
if isempty(path)
    return
end
[BPs,PWFs] = mainBatch2getSrcData(paths,needPlot,selectedPWFNames);

%评估效果
regressionErrors = evaluateRegressionEffect(BPs,coefs,PWFs',fullPath);
%%写入说明文件：测试集部分
%这里假设训练集与测试集数据都是来自于同一个dataProvider
if fid~=-1
	fprintf(fid,'%s\r\n',setMarker{2});
	for i=1:length(paths)
		[~,childPath]=fileparts(paths{i});
		fprintf(fid,'%d. %s\r\n',i,[dataProvider,'-',childPath])
	end
	fclose(fid);
end