close all

%%预定义
%采取の特征点检测方式
method = 'PEAK';
save('method.mat','method');
%绘图の设定
set(0,'DefaultFigureVisible','off');
needPlot = 0;
%存储图片の文件夹名称
name = 'MultiLinearRegression';
%说明文件の名称
readme = 'readme.md';
%说明文件中训练集与测试集の标记
setMarker = {'**trainset**','**testset**'};
%采取の脉搏波特征特征名
selectedPWFNames = {'KVAL','PRT','DPW','DPWr','DiaAr'};

disp '请选择标定数据集所在的文件夹s';
paths = uipickfiles('REFilter','\$','FilterSpec','E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\');

if isempty(path)
    return
end

%%存储截图の路径
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

disp '请选择测试数据集所在的文件夹s';
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