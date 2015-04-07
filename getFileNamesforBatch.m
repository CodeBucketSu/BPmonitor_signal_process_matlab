function [ filenames ] = getFileNamesforBatch( candidates, directory )
%GETFILENAMESFORBATCH ��directory��Ѱ�����ַ���candidates���ַ������ļ����������ļ���
%   ��������
%   candidates Ԫ��
%   directory ����·���ַ���
%   �������
%   filenames Ԫ��

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

