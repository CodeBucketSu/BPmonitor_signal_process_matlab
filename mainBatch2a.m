function mainBatch2a()
	close all

	%%Ԥ����
	%��ȡ���������ⷽʽ
	method = 'PEAK';
	save('method.mat','method');
	%��ȡ������������������
	%{'PH','PRT','DNH','DNHr','DPH',
    %'DPHr','PWA','RBAr','DBAr','DiaAr',...
    % 'SLP1','SLP2','SLP3','RBW10','RBW25',
    %'RBW33','RBW50','RBW66','RBW75','DBW10',
    %'DBW25','DBW33','DBW50','DBW66','DBW75',...
    % 'DNPT','KVAL','AmBE','DfAmBE','DNC',
    %'SC','DPW','DPWr','PDNT','PDPT'...
    % };
    cellOfSelectedPWFNames = {{};...
        {'PRT'};...
        {'PRT', 'DPHr'};...
        {'PRT', 'DNPT'};...
        {'PRT', 'DPHr', 'DNPT'};...
%         {'PRT','DPWr'};...
%         {'PRT','DPW'};...
%         {'PRT','DiaAr'};...
%         {'KVAL'};...
%         {'PDNT'};...
%         {'DNPT'};...
%         {'SLP1'};...
%         {'SLP2'};...
%         {'SLP3'};...
%         {'SLP1','SLP2','SLP3'};...
%         {'PDPT'};...
%         {'PH'};...
%         {'PRT'};...
%         {'KVAL','PRT','DPW','DPWr','DiaAr'};...
        {'KVAL','DNHr','PRT','DPW','DPWr','DiaAr'};...
%         {'DNHr','PRT','DPW','DPWr','DiaAr'};...
%         {'PDPT','PRT','DPW','DPWr','DiaAr'};...
%         {'PDNT','PRT','DPW','DPWr','DiaAr'};...
%         {'SLP1','SLP2','SLP3','PRT','DPW','DPWr','DiaAr'};...
%         {'PDPT','PDNT','DNHr','PRT','DPW','DPWr','DiaAr'};...
%         {'SLP1','SLP2','SLP3','PDPT','PDNT','DNHr','PRT','DPW','DPWr','DiaAr'};...
%         {'PRT','DPW','DPWr','DiaAr', 'DNHr','PDNT','DWB10'};...
        };
	%��ͼ���趨
	set(0,'DefaultFigureVisible','off');
	needPlot = 0;
	%�洢ͼƬ���ļ�������
	%name = 'MultiLinearRegression';
	%˵���ļ�������
	readme = 'readme.md';
	%˵���ļ���ѵ��������Լ��α��
	setMarker = {'***********trainset***********','***********testset***********'};
	trainSetSize = 2;
	testSetSize = 1;
	structItemNames = {'bp','pwf'};
	%Map��ʼ��
	featuresMap = containers.Map();
	%%1.��ȡѵ������������·������
	%1.1ѡ��ѵ����������Դ
	trainSetPaths = getAllDataPath(...
		uipickfiles('REFilter','\$','Prompt','��ѡ��궨���ݼ����ڵ��ļ��м���','FilterSpec',...
			'C:\Users\FrankSu\Documents\BP\04_softwares\interface_python\BPMonitor_git\data\young'));
	if isempty(trainSetPaths)
        disp('ѵ��������Ϊ�գ�');
	    return
	end
	%1.2ѡ����Լ�������Դ
	testSetPaths =  (...
		uipickfiles('REFilter','\$','Prompt','��ѡ��������ݼ����ڵ��ļ��м���','FilterSpec',...
            'C:\Users\FrankSu\Documents\BP\04_softwares\interface_python\BPMonitor_git\data\young'));
	if isempty(testSetPaths)
        disp('���Լ�����Ϊ�գ�');
		return
	end
	%1.3ѡ��洢��ͼ��·��
	parentPath = uigetdir(fileparts(fileparts(testSetPaths{1})),...
		'��ѡ��洢���ݵ��ļ���');
	if ~exist(parentPath)
		mkdir(parentPath);
	end
	%%2.�ϲ�������ȫ��
	fullPaths = merge2Paths(trainSetPaths,testSetPaths);
	%%3.��ÿ��·������Ѫѹ�������������ֱ��Ӧ�洢��map��
    HRs = cell(1,length(fullPaths));
    BPs = cell(1,length(fullPaths));
    PWTTs = cell(1,length(fullPaths));
    PWFs_elb = cell(1,length(fullPaths));
    PWFs_wrst = cell(1,length(fullPaths));
    PWFnames = cell(1,length(fullPaths));

	for i=1:length(fullPaths)
		[HRs{i}, BPs{i}, PWTTs{i}, PWFs_elb{i}, PWFs_wrst{i}, PWFnames{i}] = mainFunc2(fullPaths{i},needPlot);
		% bps = 0;
		% pwfs = 0;
		end
	%%4.��ȡ���е�ѵ��-�������ϣ��ֱ������Ͻ�������洢
	allTrainPaths = randomSelectPathModule(trainSetPaths,trainSetSize);
	allTestPaths = randomSelectPathModule(testSetPaths,testSetSize);
    
    for cnt = 1 : length(cellOfSelectedPWFNames)        
        selectedPWFNames = cellOfSelectedPWFNames{cnt};
        for i=1:length(fullPaths)
            featuresMap(fullPaths{i})= struct(structItemNames{1},{{BPs{i}}},structItemNames{2},...
                {{selectPWFs(HRs{i}, PWTTs{i}, PWFs_elb{i}, PWFs_wrst{i}, PWFnames{i},selectedPWFNames)}});
        end
        
        %%4.1Ӧ��ѵ����·�����ɴ洢ͼƬ��˵���ĵ���·��
        for i=1:length(allTrainPaths)
		trainPaths = allTrainPaths{i};
		%��Ͻ�ͼ����·��
		fullPath = fullfile(parentPath, ...
			['trainSetSize-',num2str(trainSetSize),...	
			' testSetSize-',num2str(testSetSize),...		 
			' trainSetNum-',num2str(i)]);
		if ~exist(fullPath)
			mkdir(fullPath);
		end
		%%4.2д��˵���ļ�:ѵ����
		%%���Խ�ͼ�ļ����������������������+ʹ�õ��㷨+Ψһ���
		name = ['Trainset-',num2str(i),'-',...
				connectCellStrArray(selectedPWFNames),'-',num2str(getANum(fullPath))];			

		fid = fopen(fullfile(fullPath,readme),'a+');
		if fid~=-1
			fprintf(fid,'\r\n\r\n%s\r\n',setMarker{1});
			fprintf(fid,'%s\r\n',name);
			for i=1:length(trainPaths)
				fprintf(fid,'%d. %s\r\n',i,getShortenPath(trainPaths{i}))
			end
			fprintf(fid,'%s\r\n',setMarker{2});
			fclose(fid);
		end
		%%4.3���
		[bps,PWFs] = mergeDataInMap(trainPaths,featuresMap,structItemNames);		
		[coefs,errors,corrs] = linearRegression(bps,PWFs',fullPath,name);
		saveDataToMat(fullPath,name,coefs,errors,corrs,true);
		for j=1:length(allTestPaths)
			testPaths = allTestPaths{j};
			%�ж������Ƿ��н���
			if hasRepeatElements(trainPaths,testPaths)
				continue;
			end
			%���Խ�ͼ����·��
			%ѵ��+��������С>=ȫ����Сʱ��ֱ�Ӵ�����Ͻ�ͼ����·��
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
			%%4.4д��˵���ļ�:���Լ�
			name = ['Testset-',num2str(i),'-',num2str(j),'-',...
				connectCellStrArray(selectedPWFNames),'-',num2str(getANum(savePath))];
			writeAnItemInfoToReadMe(savePath,...
				struct('name',{{name}},'paths',{testPaths}));
			%4.5 ����
			[testBPs,testPWFs] = mergeDataInMap(testPaths,featuresMap,structItemNames);
			%%���Խ�ͼ�ļ����������������������+������������+ʹ�õ��㷨+Ψһ���
			[regressionErrors,regressionCorrs] = evaluateRegressionEffect(testBPs,coefs,testPWFs'...
				,savePath,name);
			saveDataToMat(savePath,name,coefs,regressionErrors,regressionCorrs,false);

		end
        end
    end
	% feature('DefaultCharacterSet',encodeMethod);
	set(0,'DefaultFigureVisible','on');
end

function shortPath = getShortenPath(fullpath)
	[parentPath,dirname] = fileparts(fullpath);
	[~,dataProvider] = fileparts(parentPath);
	shortPath = fullfile(dataProvider,dirname);
end

function saveDataToMat(matpath,name,coefs,meanerrors,corrs,isTrainset)
	%% saveDataToMat����ϻ���Խ��д�뵽һ��mat�ļ���
	% INPUT
	% name char���� ��ϻ�����ļ���
	% coefs nά���� ���ϵ��
	% meanerrors 3ά���� M/S/DBPƽ�����
	% corrs 3ά���� M/S/DBP�����
	% isTrainset bool �Ƿ�ѵ����
	matname = '.result.mat';

	matname = fullfile(matpath,matname);
	if isTrainset
		if exist(matname)
			load(matname);
			trainSetNameCell = addAnItemToCell(name,trainSetNameCell);
			trainSetCoefsCell = addAnItemToCell({coefs},trainSetCoefsCell);
			trainSetErrorsMat = addARowToMat(meanerrors(:)',trainSetErrorsMat);
			trainSetCorrsMat = addARowToMat(corrs(:)',trainSetCorrsMat);
		else
			trainSetNameCell = {name};
			trainSetCoefsCell = {{coefs}};
			trainSetErrorsMat = meanerrors(:)';
			trainSetCorrsMat = corrs(:)';
			testSetNameCell={};
			testSetCoefsCell={};
			testSetErrorsMat=[];
			testSetCorrsMat=[];
		end
	else
		if exist(matname)
			load(matname);
			testSetNameCell = addAnItemToCell(name,testSetNameCell);
			testSetCoefsCell = addAnItemToCell({coefs},testSetCoefsCell);
			testSetErrorsMat = addARowToMat(meanerrors(:)',testSetErrorsMat);
			testSetCorrsMat = addARowToMat(corrs(:)',testSetCorrsMat);
		else
			testSetNameCell = {name};
			testSetCoefsCell = {{coefs}};
			testSetErrorsMat = meanerrors(:)';
			testSetCorrsMat = corrs(:)';
			trainSetNameCell={};
			trainSetCoefsCell={};
			trainSetErrorsMat=[];
			trainSetCorrsMat=[];	
		end	
	end	
	save(matname,...
		'testSetNameCell','trainSetNameCell',...
		'testSetCoefsCell','trainSetCoefsCell',...
		'testSetErrorsMat','trainSetErrorsMat',...
		'testSetCorrsMat','trainSetCorrsMat');
end

function mat4return = addARowToMat(row,mat)
	row = row(:)';
	if isempty(mat)
		mat4return = row;
	elseif length(mat(1,:)) == length(row)
		mat4return = [mat;row];
	else
		mat4return = mat;
	end
end

function cell4return = addAnItemToCell(item,cellin)
	cellin = cellin';
	cell4return = {cellin{:},item}';
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
	%% writeAnItemInfoToReadMe��һ���̶��ṹ��struct��Ϣд�뵽path�µ�readme.md��
	%% infoStruct struct�ṹ
	% ...name ͼƬ�ļ���
	% ...paths cell���� ������·��

	filename = 'readme.md';
	fid = fopen(fullfile(path,filename),'a+');
	if fid~=-1
		%num = infoStruct.num;
		%fprintf(fid,'Image Num: %d\r\n',num);
		tName = infoStruct.name;
		fprintf(fid,'%s\r\n',tName{:});
		tPaths = infoStruct.paths;
		for i=1:length(tPaths)
			fprintf(fid,'%s\r\n',getShortenPath(tPaths{i}));
		end
		fclose(fid);
	end
end

function connectedStr = connectCellStrArray(C2)
	%% connectCellStrArray����һ��cell array������һ���ַ���
	C2(2,:) = {'-'};
	C2{2,end} = '';
	connectedStr = [C2{:}];
end

function b = hasRepeatElements(pathsa,pathsb)
	%% hasRepeatElements�ж������ַ����������Ƿ�����ظ�
	for i=1:length(pathsb)
		for j=1:length(pathsa)
			if strcmp(pathsb{i},pathsa{j})==1
				b = true;
				return;
			end
		end;
	end
	b = false;
	end

function dirname = getParentFolderName(path)
	[~,dirname] = fileparts(fileparts(path));
	end

function [paths,hasRepeatElements] = merge2Paths(pathsa,pathsb)
	%%merge2Paths�ں�����cell�ַ������飬���ɲ������ظ�Ԫ�ص�cell�ַ�������
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
    	%�˴���Ҫ���ַ���תΪ�ṹ����
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

function [PWFs] = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst,PWFnames,selectedPWFNames)
%�����ⲿ����������
useElb = 0;
%���õ�n��PWTT
selectedPwttNum = 4;
%���õ�����������������
PWFs(1,:) = PWTTs(selectedPwttNum,:);   currRow = 1;
% PWFs(currRow,:) = HRs;   currRow = 2;5
for j=1:length(selectedPWFNames)
        for i=1:length(PWFnames)
                if strcmp(PWFnames{i},selectedPWFNames{j})
                    if useElb == 1
                        PWFs(currRow+j,:) = PWFs_elb(i,:);
                    else
                        PWFs(currRow+j,:) = PWFs_wrst(i,:);
                    end
                    break;
                end
        end
end
    
end