function paths = getAllDataPath(pathcell)	
	paths = {};
	for i=1:length(pathcell)
		tPath = recursivelySearchPath(generateResult(pathcell{i}),0);
		paths = {paths{:},tPath{:}};
	end
end

function [paths,isPathWhatWeWant] = recursivelySearchPath(pathStruct,depth)
	%recursivelySearchPath用于递归获取所有符合条件的目录
	%找到所有可能的路径：以20作为开头的文件夹，且文件夹下包含一个‘data’文件夹
	%定义父文件夹合法前缀
	parentFolderPref = '20';
	%搜索可能包含数据的子文件夹的最大层数
	maxSearchDepth = 3;
	isPathWhatWeWant = false;
	paths = {};
	if pathStruct.isdir && depth<=maxSearchDepth
		depth = depth+1;
		[~,dirName] = fileparts(pathStruct.name);
		[dirs,marker] = getDirsUnderPath(pathStruct.name);
		if isempty(dirs)
			return;
		end
		if strStartsWith(dirName, parentFolderPref) && marker
			%不在符合条件的文件夹下继续查找
			isPathWhatWeWant = true;			
			paths = {pathStruct.name};
			return;
		end
		for i=1:length(dirs)
			disp(dirs{i});
			[returnPaths,isPathWhatWeWant] = recursivelySearchPath(generateResult(dirs{i}),depth);
			if isPathWhatWeWant
				paths = {paths{:},returnPaths{:}};
			end
		end
	end
end

function [dirs,hasDirNamedByData] = getDirsUnderPath(path)
	%定义子文件夹名称
	targetDirName = 'data';
	hasDirNamedByData = false;
	dirs = {};
	dirStructs = rdir(path);
	len = 1;
	for i = 1:length(dirStructs)
		if(dirStructs(i).isdir)
			dirs{len}=dirStructs(i).name;
			[~,dirname]=fileparts(dirStructs(i).name);
			if strcmp(dirname,targetDirName) == 1
				hasDirNamedByData = true;
			end
			len = len+1;			
		end
	end
end

function b = strStartsWith(s, pat)
%STRSTARTSWITH Determines whether a string starts with a specified pattern
%
%   b = strstartswith(s, pat);
%       returns whether the string s starts with a sub-string pat.
%

%   History
%   -------
%       - Created by Dahua Lin, on Oct 9, 2008
%
%% main
	sl = length(s);
	pl = length(pat);

	b = (sl >= pl && strcmp(s(1:pl), pat)) || isempty(pat);
end

function resultStruct = generateResult(path)
	resultStruct = struct('name',path,'isdir',isdir(path));
end