clc, clear, close all
needPlot = 1;

figs = [];

%% 选取数据所在文件夹
[filePath] = uigetdir('E:\study\code\young\wl\2014_10_28_16_37_processed', ...
    '请选择数据所在的文件夹：请确保该文件夹下存在名为“data”和“result”的文件夹！');
filePathForDate = [filePath, '\data'];
filePathForSave = [filePath, '\result'];
formulas = {'MK-MODEL', 'POWER', 'LINEAR', 'QUADRIC'};

%% 处理运动前的信号
fileNames = {'pf.mat'};  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, PWTTs, MBPs, DBPs, SBPs, corrPwttHrs, ...
    meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, ...
    corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computeAll(filePathForDate, fileNames, needPlot, '标定数据');
saveas(figCorr, [filePathForSave, '/标定数据：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/标定数据：PWTT与BP的相关性'], 'jpg');

%% 处理静止（改变姿态）测试集信号
fileNames = {'static.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_static, PWTTs_static, MBPs_static, DBPs_static, SBPs_static, corrPwttHrs_static, ... 
    meanHR_static, meanPWTT_static, meanBP_static, varHR_static, varPWTT_static, varBP_static, ...
    corrPwttBpTotal_static, corrPwttHrTotal_static, corrBpHrTotal_static, figCorr] = computeAll(filePathForDate, fileNames, needPlot, '静止或改变姿态');
saveas(figCorr, [filePathForSave, '/静止或改变姿态：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/静止或改变姿态：PWTT与BP的相关性'], 'jpg');

%% 处理憋气测试集信号
fileNames = {'bq.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hx.mat', 'hs.mat'
[HRs_bq, PWTTs_bq, MBPs_bq, DBPs_bq, SBPs_bq, corrPwttHrs_bq, ... 
    meanHR_bq, meanPWTT_bq, meanBP_bq, varHR_bq, varPWTT_bq, varBP_bq, ...
    corrPwttBpTotal_bq, corrPwttHrTotal_bq, corrBpHrTotal_bq, figCorr] = computeAll(filePathForDate, fileNames, needPlot, '改变呼吸');
saveas(figCorr, [filePathForSave, '/改变呼吸：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/改变呼吸：PWTT与BP的相关性'], 'jpg');

%% 处理喝水测试集信号
fileNames = {'hs.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_hs, PWTTs_hs, MBPs_hs, DBPs_hs, SBPs_hs, corrPwttHrs_hs, ... 
    meanHR_hs, meanPWTT_hs, meanBP_hs, varHR_hs, varPWTT_hs, varBP_hs, ...
    corrPwttBpTotal_hs, corrPwttHrTotal_hs, corrBpHrTotal_hs, figCorr] = computeAll(filePathForDate, fileNames, needPlot, '喝水');
saveas(figCorr, [filePathForSave, '/喝水：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/喝水：PWTT与BP的相关性'], 'jpg');

%% 标定并验证
fig = figure('Name', ' 标定数据'); 
calibrateAndPlot(MBPs, PWTTs(9, :), 'POWER');
saveas(fig, [filePathForSave, '/标定数据：标定后估计血压'], 'fig');
set(fig, 'PaperPositionMode', 'auto');
saveas(fig, [filePathForSave, '/标定数据：标定后估计血压'], 'jpg');
% 用静止数据验证
[MSEs_static, MEs_static, SVEs_static, CORRs_static, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
    (MBPs, PWTTs, MBPs_static, PWTTs_static, formulas, mean(corrPwttHrs_static, 2), '静止或改变姿态');
saveas(figEst, [filePathForSave, '/静止或改变姿态：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/静止或改变姿态：标定后估计血压'], 'jpg');
% 用憋气数据验证
[MSEs_bq, MEs_bq, SVEs_bq, CORRs_bq, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
    (MBPs, PWTTs, MBPs_bq, PWTTs_bq, formulas, mean(corrPwttHrs_bq, 2), '改变呼吸');
saveas(figEst, [filePathForSave, '/改变呼吸：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/改变呼吸：标定后估计血压'], 'jpg');
% 用喝水数据验证
[MSEs_hs, MEs_hs, SVEs_hs, CORRs_hs, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
    (MBPs, PWTTs, MBPs_hs, PWTTs_hs, formulas, mean(corrPwttHrs_hs, 2), '喝水');
saveas(figEst, [filePathForSave, '/喝水：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/喝水：标定后估计血压'], 'jpg');

save([filePathForSave, '/results.mat']);
