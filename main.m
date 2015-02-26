clc, clear, close all
needPlot = 0;


%% 选取数据所在文件夹
%[filePath] = uigetdir(['Y:\code\young\syl',...
[filePath] = uigetdir('D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young',... % for syl
    '请选择数据所在的文件夹：请确保该文件夹下存在名为“data”和“result”的文件夹！');
filePathForDate = [filePath, '/data'];
filePathForSave = [filePath, '/result'];
formulas = {'MK-MODEL', 'POWER', 'LINEAR', 'QUADRIC'};

%% 处理运动前的信号
fileNames = {'pf.mat'};  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '标定数据');
saveFigures(figures, filePathForSave, ...
    {'标定数据：PWTT与BP的相关性'; '标定数据：PWF_elbw与BP的相关性';  '标定数据：PWF_wrst与BP的相关性'});

%% 处理运动后测试集信号
% fileNames = {'ydh.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
% [HRs_ydh, BPs_ydh, PWTTs_ydh, PWFs_elb_ydh, PWFs_wrst_ydh, PWFnames_ydh, ...
%     PWTTstats_ydh, PWFstats_elb_ydh, PWFstat_wrst_ydh, corrBpHr_ydh, figures]...
%     = computeAll(filePathForDate, fileNames, needPlot, '静止或改变姿态');
% saveFigures(figures, filePathForSave, ...
%     {'静止或改变姿态：PWTT与BP的相关性'; '静止或改变姿态：PWF_elbw与BP的相关性';  '静止或改变姿态：PWF_wrst与BP的相关性'});

%% 处理静止（改变姿态）测试集信号
fileNames = {'static.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_static, BPs_static, PWTTs_static, PWFs_elb_static, PWFs_wrst_static, PWFnames_static, ...
    PWTTstats_static, PWFstats_elb_static, PWFstat_wrst_static, corrBpHr_static, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '静止或改变姿态');
saveFigures(figures, filePathForSave, ...
    {'静止或改变姿态：PWTT与BP的相关性'; '静止或改变姿态：PWF_elbw与BP的相关性';  '静止或改变姿态：PWF_wrst与BP的相关性'});

% %% 处理憋气测试集信号
% fileNames = {'bq.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hx.mat', 'hs.mat'
% [HRs_bq, PWTTs_bq, MBPs_bq, DBPs_bq, SBPs_bq, corrPwttHrs_bq, ... 
%     meanHR_bq, meanPWTT_bq, meanBP_bq, varHR_bq, varPWTT_bq, varBP_bq, ...
%     corrPwttBpTotal_bq, corrPwttHrTotal_bq, corrBpHrTotal_bq, figCorr, ...
%     features_elbow_bq, features_wrist_bq] = computeAll(filePathForDate, fileNames, needPlot, '改变呼吸');
% saveFigure(figCorr, filePathForSave, '改变呼吸：PWTT与BP的相关性');
% 
% %% 处理喝水测试集信号
% fileNames = {'hs.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
% [HRs_hs, PWTTs_hs, MBPs_hs, DBPs_hs, SBPs_hs, corrPwttHrs_hs, ... 
%     meanHR_hs, meanPWTT_hs, meanBP_hs, varHR_hs, varPWTT_hs, varBP_hs, ...
%     corrPwttBpTotal_hs, corrPwttHrTotal_hs, corrBpHrTotal_hs, figCorr, ...
%     features_elbow_hs, features_wrist_hs] = computeAll(filePathForDate, fileNames, needPlot, '喝水');
% saveFigure(figCorr, filePathForSave, '喝水：PWTT与BP的相关性');

%% 标定并验证
% fig = figure('Name', ' 标定数据'); 
% calibrateAndPlot(BPs(3, :), PWTTs(9, :), 'POWER');
% saveas(fig, [filePathForSave, '/标定数据：标定后估计血压'], 'fig');
% set(fig, 'PaperPositionMode', 'auto');
% saveas(fig, [filePathForSave, '/标定数据：标定后估计血压'], 'jpg');
%% 用静止数据验证
% [MSEs_static, MEs_static, SVEs_static, CORRs_static, figEst] = calibrateAndComputeBPwithFeaturesAndDifferentModel...
%     (BPs(3, :), PWTTs, BPs_static(3, :), PWTTs_static, formulas, PWTTstats_static_static(:, 3), '静止或改变姿态：用PWTT估计血压');
% saveFigure(figCorr, filePathForSave, '静止或改变姿态：标定后估计血压');

% [MSEs_static, MEs_static, SVEs_static, CORRs_static, figEst] = calibrateAndComputeBPwithFeaturesAndDifferentModel...
%     (BPs(3, :), PWFs_wrst, BPs_static(3, :), PWFs_wrst_static, formulas, PWFstat_wrst_static(:, 3), '静止或改变姿态：用PWF估计血压');

% % 用憋气数据验证
% [MSEs_bq, MEs_bq, SVEs_bq, CORRs_bq, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
%     (MBPs, PWTTs, MBPs_bq, PWTTs_bq, formulas, mean(corrPwttHrs_bq, 2), '改变呼吸');
% saveFigure(figCorr, filePathForSave, '改变呼吸：标定后估计血压');
% % 用喝水数据验证
% [MSEs_hs, MEs_hs, SVEs_hs, CORRs_hs, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
%     (MBPs, PWTTs, MBPs_hs, PWTTs_hs, formulas, mean(corrPwttHrs_hs, 2), '喝水');
% saveFigure(figCorr, filePathForSave, '喝水：标定后估计血压');

save([filePathForSave, '/result.mat']);


