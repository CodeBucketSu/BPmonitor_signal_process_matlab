function [ filenames ] = getFileNamesforBatch( candidates, directory )
%GETFILENAMESFORBATCH 在directory下寻找名字符合candidates中字符串的文件，并返回文件名
%   输入类型
%   candidates 元胞
%   directory 绝对路径字符串
%   输出类型
%   filenames 元胞

files = dir(directory);
filenames = {};
filenum = 1;
for i = 1:length(files)
    if ~files(i).isdir
        for j = 1:length(candidates)
            if ~isempty(strfind(files(i).name,candidates{j}))
                filenames{filenum} = files(i).name;
                filenum = filenum+1;
                break;
            end
        end
    end
end              
                
end

