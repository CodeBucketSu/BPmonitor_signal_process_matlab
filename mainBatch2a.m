function mainBatch2a()
	close all

	%%预定�?
	%采取の特征点�?��方式
	method = 'PEAK';
	save('method.mat','method');
	%采取の脉搏波特征特征�?
	selectedPWFNames = {'KVAL'};%,'PRT','DPW','DPWr','DiaAr','DNHr'
	%绘图の设�?
	set(0,'DefaultFigureVisible','off');
	needPlot = 0;
	%存储图片の文件夹名称
	name = 'MultiLinearRegression';
	%说明文件の名�?
	readme = 'readme.md';
	%说明文件中训练集与测试集の标�?
	setMarker = {'**trainset**','**testset**'};
	trainSetSize = 3;
	testSetSize = 2;
	structItemNames = {'bp','pwf'};
	%Map初始�?
	featuresMap = containers.Map();
	%%1.获取训练集与样本集路径集�?
	%1.1选择训练集数据来�?
	disp '请�?择标定数据集�?��的文件夹集合';
	trainSetPaths = getAllDataPath(...
		uipickfiles('REFilter','\$','FilterSpec',...
			'E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\'));
	if isempty(trainSetPaths)
	    return
	end
	%1.2选择测试集数据来�?
	disp '请�?择测试数据集�?��的文件夹集合';
	testSetPaths = getAllDataPath(...
		uipickfiles('REFilter','\$','FilterSpec',fileparts(trainSetPaths{1})));
	if isempty(testSetPaths)
		return
	end
	%%2.合并，生成全�?
	fullPaths = merge2Paths(trainSetPaths,testSetPaths);
	%%3.对每个路径计算血压脉搏波特征，分别对应存储到map�?
	for i=1:length(fullPaths)
		[bps,pwfs] = mainFunc2(fullPaths{i},needPlot,selectedPWFNames);
		featuresMap(fullPaths{i})= struct(structItemNames{1},{{bps}},structItemNames{2},{{pwfs}});
		end
	%%4.获取�?��的训�?样本集合，分别计算拟合结果，并存�?
	allTrainPaths = randomSelectPathModule(trainSetPaths,trainSetSize);
	allTestPaths = randomSelectPathModule(testSetPaths,testSetSize);
	%%4.1应用训练集路径生成存储图片与说明文档的路�?
		%存储截图の根路径
	parentPath = fileparts(allTrainPaths{1}{1});
	[parentPath dataProvider] = fileparts(parentPath);
	parentPath = fullfile(parentPath,name);
	if ~exist(parentPath)
		mkdir(parentPath);
	end
	for i=1:length(allTrainPaths)
		trainPaths = allTrainPaths{i};
		%拟合截图の子路径
		fullPath = fullfile(parentPath, ...
			['trainSetSize-',num2str(trainSetSize),...	
			' testSetSize-',num2str(testSetSize),...		 
			' trainSetNum-',num2str(i)]);
		if ~exist(fullPath)
			mkdir(fullPath);
		end
		%%4.2写入说明文件:训练�?
		if ~exist(fullfile(fullPath,readme))
			fid = fopen(fullfile(fullPath,readme),'w+');
			if fid~=-1
				fprintf(fid,'%s\r\n',setMarker{1});
				for i=1:length(trainPaths)
					[~,childPath]=fileparts(trainPaths{i});
					fprintf(fid,'%d. %s\r\n',i,trainPaths{i})
				end
				fprintf(fid,'%s\r\n',setMarker{2});
				fclose(fid);
			end
		end
		%%4.3拟合
		%文件命名：trainset
		[BPs,PWFs] = mergeDataInMap(trainPaths,featuresMap,structItemNames);		
		[coefs,errors] = linearRegression(BPs,PWFs',fullPath);
		for j=1:length(allTestPaths)
			testPaths = allTestPaths{j};
			%判断两�?是否有交�?
			if hasRepeatElements(trainPaths,testPaths)
				break;
			end
			%测试截图の子路径
			%训练+样本集大�?=全集大小时，直接存入拟合截图の子路径
			% if trainSetSize+testSetSize >= length(fullPaths)
			% 	savePath = fullPath;
			% else
			% 	savePath = fullfile(fullPath, ...
			% 	[datestr(now, 'yyyy-mm-dd-HH-MM-SS') '-testset from '...
			% 	 getParentFolderName(testPaths{1})]);
			% 	if ~exist(savePath)
			% 		mkdir(savePath);
			% 	end
			% end
			savePath = fullPath;
			%%4.4写入说明文件:测试�?
			name = [num2str(j),'-',num2str(i),'-',...
				connectCellStrArray(selectedPWFNames),'-',num2str(getANum(savePath))];
			writeAnItemInfoToReadMe(savePath,...
				struct('name',{{name}},'paths',{testPaths}));
			%4.5 测试
			[testBPs,testPWFs] = mergeDataInMap(testPaths,featuresMap,structItemNames);
			%%测试截图文件名命名规则：测试数据组编�?拟合数据组编�?使用的算�?唯一编号
			regressionErrors = evaluateRegressionEffect(testBPs,coefs,testPWFs'...
				,savePath,name);
		end
	end
end

function num = getANum(path)
	num = readNumFromMat(path);
	saveNumToMat(path,num+1);
end

function num = readNumFromMat(path)
	filename = '.num.mat';
	if exist(fullfile(path,filename))
		num = load(fullfile(path,filename));
		num = num.num;
	else
		num = 1;
	end
end

function saveNumToMat(path,num)
	filename = '.num.mat';
	save(fullfile(path,filename),'num');
end

function num = writeAnItemInfoToReadMe(path,infoStruct)
	%% writeAnItemInfoToReadMe将一个固定结构的struct信息写入到path下的readme.md�?
	%% infoStruct struct结构
	% ...name 图片文件�?
	% ...paths cell数组 包含的路�?

	filename = 'readme.md';
	fid = fopen(fullfile(path,filename),'a+');
	if fid~=-1
		%num = infoStruct.num;
		%fprintf(fid,'Image Num: %d\r\n',num);
		tName = infoStruct.name;
		fprintf(fid,'%s\r\n',tName{:});
		tPaths = infoStruct.paths;
		for i=1:length(tPaths)
			fprintf(fid,'%s\r\n',tPaths{i});
		end
		fclose(fid);
	end
end

function connectedStr = connectCellStrArray(C2)
	%% connectCellStrArray连接�?��cell array，返回一个字符串
	C2(2,:) = {'-'};
	C2{2,end} = '';
	connectedStr = [C2{:}];
end

function b = hasRepeatElements(pathsa,pathsb)
	%% hasRepeatElements判断两个字符串数组中是否存在重复
	for i=1:length(pathsb)
		for j=1:length(pathsa)
			if strcmp(pathsb{i},pathsa{j})==1
				b = true;
			end
		end;
	end
	b = false;
	end

function dirname = getParentFolderName(path)
	[~,dirname] = fileparts(fileparts(path));
	end

function [paths,hasRepeatElements] = merge2Paths(pathsa,pathsb)
	%%merge2Paths融合两个cell字符串数组，生成不包含重复元素的cell字符串数�?
	paths = {};
	for i=1:length(pathsb)
		isRepeat = 0;
		for j=1:length(pathsa)
			if strcmp(pathsb{i},pathsa{j})==1
				isRepeat = 1;
				break;
			end
		end
		if isRepeat == 0
			paths={paths{:},pathsb{i}};
		end
	end
	paths={paths{:},pathsa{:}};
	end

function [BPs,PWFs] = mergeDataInMap(paths,map,mapNames)
    BPs = [];
    PWFs = [];
    for i=1:length(paths)
    	%此处�?��把字符串转为结构属�?
    	bps = map(paths{i}).bp;
    	pwfs = map(paths{i}).pwf;
        bps = bps{:};
        pwfs = pwfs{:};
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