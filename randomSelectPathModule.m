function [trainSetPaths, testSetPaths] = randomSelectPathModule_backup(varargin)
%selectSrcDataMoudle用于随机选取测试集与训练集数据
%OUTPUT
%trainSetPaths    n×m元胞    
%先找到所有可能的训练集路径：以2作为开头的文件夹，且文件夹下包含一个‘data’文件夹
%再找到所有可能的n种不同路径组合，使每种组合包含m个路径
%testSetPaths    p×q元胞	
%先找到所有可能的测试集路径：以2作为开头的文件夹，且文件夹下包含一个‘data’文件夹
%再找到所有可能的p种不同路径组合，使每种组合包含q个路径


%获取训练集路径
trainSetPaths = randomSelectElementsInArray(generatePaths(trainSetPaths),trainSetSize);
%获取测试集路径
testSetPaths = randomSelectElementsInArray(generatePaths(testSetPaths),testSetSize);;
end

function resultPaths = generatePaths(paths)
	resultPaths = {};
	for i=1:length(paths)
		tPaths = getAllDataPath(generateResult(paths{i}));
		resultPaths = {resultPaths{:},tPaths{:}};
	end	
end

function resultStruct = generateResult(path)
	resultStruct = struct('name',path,'isdir',isdir(path));
end

function elements = randomSelectPathModule(cellArray,num)
	%%randomSelectPathModule找到所有从string数组中挑选出num个string的组合
	if num>=length(cellArray)
		%只有一种组合
		elements={cellArray};
	else
		elements = {};

		pos = linspace(1,length(cellArray),length(cellArray));
		poses = nchoosek(pos,num);

		for i=1:length(poses(:,1))
			element = cell(1,num);
			for j=1:num
				element{j} = cellArray{poses(i,j)};
			end
			elements={elements{:},element};
		end
	end
	end