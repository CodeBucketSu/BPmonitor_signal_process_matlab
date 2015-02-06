function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = mainFunc( directory,method )
%MAINFUNC 代替原来的main函数在批处理中调用，每次获取一种方法对应的3个相关矩阵
%   输入
%   directory 字符串类型 数据所在的processed目录
%   method 字符串类型 "PEAK" "DISTANCE" "WAVELET" 采取的方法 

%% 选取数据所在文件夹
filepath = directory;
filePathForDate = [filePath, '/data'];
filePathForSave = [filePath, '/result'];

%% 处理运动前的信号
fileNames = {'pf.mat', 'xc.mat' };  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '标定数据');
saveFigures(figures, filePathForSave, ...
    {'标定数据：PWTT与BP的相关性'; '标定数据：PWF_elbw与BP的相关性';  '标定数据：PWF_wrst与BP的相关性'});

save([filePathForSave, '/result.mat']);
end

