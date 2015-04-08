function mainBatch2a()
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
	trainSetSize = 3;
	testSetSize = 2;
	structItemNames = {'bp','pwf'};

	%%1.获取训练集与样本集路径集合
	%1.1选择训练集数据来源
	disp '请选择标定数据集所在的文件夹集合';
	trainSetPaths = getAllDataPath(...
		uipickfiles('REFilter','\$','FilterSpec',...
			'E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\'));
	if isempty(trainSetPaths)
	    return
	end
	%1.2选择测试集数据来源
	disp '请选择测试数据集所在的文件夹集合';
	testSetPaths = getAllDataPath(...
		uipickfiles('REFilter','\$','FilterSpec',fileparts(trainSetPaths)));
	if isempty(testSetPaths)
		return
	end
	%%2.合并，生成全集
	fullPaths = merge2Paths(trainSetPaths,testSetPaths);
	%%3.对每个路径计算血压脉搏波特征，分别对应存储到map内
	for i=1:length(fullPaths)
		[bps,pwfs] = mainFunc2(fullPaths{i},needPlot);
		featuresMap(fullPaths{i})= struct(structItemNames{1},bps,structItemNames{2},pwfs);
		end
	%%4.获取所有的训练-样本集合，分别计算拟合结果，并存储
	allTrainPaths = randomSelectPathModule(trainSetPaths,trainSetSize);
	allTestPaths = randomSelectPathModule(testSetPaths,testSetSize);
	for i=1:length(allTrainPaths)
		trainPaths = allTrainPaths{i};
		%%4.1应用训练集路径生成存储图片与说明文档的路径
		%%存储截图の路径
		parentPath = fileparts(allTrainPaths{1}{1});
		[parentPath dataProvider] = fileparts(parentPath);
		fullPath = fullfile(parentPath,name);
		if ~exist(fullPath)
			mkdir(fullPath);
		end
		fullPath = fullfile(fullPath, ...
			[datestr(now, 'yyyy-mm-dd-HH-MM-SS') '-trainset from' dataProvider])
		mkdir(fullPath);
		%%4.2写入说明文件:训练集
		fid = fopen(fullfile(fullPath,readme),'w+');
		if fid~=-1
			fprintf(fid,'%s\r\n',setMarker{1});
			for i=1:length(trainPaths)
				[~,childPath]=fileparts(paths{i});
				fprintf(fid,'%d. %s\r\n',i,[dataProvider,'-',childPath])
			end
		end
		%%4.3拟合
		[BPs,PWFs] = mergeDataInMap(trainPaths,featuresMap,structItemNames);
		[coefs,errors] = linearRegression(BPs,PWFs',fullPath);
		for j=1:length(allTestPaths)
			testPaths = allTestPaths{j};
			%%4.4写入说明文件:测试集
			fprintf(fid,'%s\r\n',setMarker{2});
			for i=1:length(testPaths)
				[~,childPath]=fileparts(paths{i});
				fprintf(fid,'%d. %s\r\n',i,[dataProvider,'-',childPath])
			end
			%4.5 测试
			[testBPs,testPWFs] = mergeDataInMap(trainPaths,featuresMap,structItemNames)；
			regressionErrors = evaluateRegressionEffect(testBPs,coefs,testPWFs',fullPath);
		end
		end

	set(0,'DefaultFigureVisible','on');
end

function paths = merge2Paths(pathsa,pathsb)
	%%merge2Paths融合两个cell字符串数组，生成一个不重复的cell字符串数组
	paths = {};
	for i=1:length(pathsa)
		for j=1:length(pathsb)
			if strcat(pathsa{i},pathsb{j})~=1
				paths={paths{:},pathsa{i}};
			end
		end
	end
	paths={paths{:},pathsb{:}};
	end

function [BPs,PWFs] = mergeDataInMap(paths,map,mapNames)
    BPs = [];
    PWFs = [];
    for i=1:length(paths)
    	bps = map(paths{i}).mapNames[1];
    	pwfs = map(paths{i}).mapNames[2];
        if isempty(BPs)
             BPs = bps;
        else
             BPs = [BPs bps];
        end
        if isempty(PWFs)
            PWFs=pwfs;
        else
            PWFs=[PWFs,pwfs];
        end
    end
end