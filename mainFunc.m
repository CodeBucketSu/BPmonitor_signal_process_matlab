function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = mainFunc( method,dataType,path )
%MAINFUNC 代替原来的main函数在批处理中调用，每次获取一种方法对应的3个相关矩阵
%   输入
%   method 字符串类型 "PEAK" "DISTANCE" "WAVELET" 采取的方法 
%   dataType 字符串类型 "CALIBRITION" "EXERCISE" "STATIC"
%   path 字符串类型 数据所在的processed目录

%%预定义
needPlot = 0;
save('method.mat','method');
% 这些是相关
pwttcorr = [];
pwfcorrelb = [];
pwfcorrwrt = [];

if strcmp(dataType,'CALIBRITION')
    candidates = {'pf','xc','sj'};
    fileNameforSave = '/result_cali.mat';
elseif strcmp(dataType,'EXERCISE')
    candidates = {'ydh'};
    fileNameforSave = '/result_exec.mat';
else
    candidates = {'static'};
    fileNameforSave = '/result_stat.mat';
end

%% 选取数据所在文件夹
filePathForData = [path, '/data'];
filePathForSave = [path, '/result'];

%% 处理信号
fileNames = getFileNamesforBatch(candidates,filePathForData); 
if isempty(fileNames)
    return
end
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForData, fileNames, needPlot, '标定数据');
% saveFigures(figures, filePathForSave, ...
%     {'标定数据：PWTT与BP的相关性'; '标定数据：PWF_elbw与BP的相关性';  '标定数据：PWF_wrst与BP的相关性'});

save([filePathForSave, fileNameforSave]);
%%返回
pwttcorr = PWTTstats;
pwfcorrelb = PWFstats_elb;
pwfcorrwrt = PWFstat_wrst;

end

