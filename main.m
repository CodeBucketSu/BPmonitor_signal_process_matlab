clc, clear, close all

figs = [];

%% 选取数据所在文件夹
[filePath] = uigetdir('D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young', ...
    '请选择数据所在的文件夹');

filePathForSave = uigetdir(filePath, '请选择数据要保存的文件夹');

formulas = {'MK-MODEL', 'POWER', 'LINEAR', 'QUADRIC'};

%% 处理运动前的信号
fileNames = {'pf.mat'};  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, PWTTs, MBPs, DBPs, SBPs, corrPwttHrs, ...
    meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, ...
    corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computeAll(filePath, fileNames, '标定数据');
saveas(figCorr, [filePathForSave, '/标定数据：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/标定数据：PWTT与BP的相关性'], 'jpg');

%% 处理静止（改变姿态）测试集信号
fileNames = {'gesture.mat', 'gesture1.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_static, PWTTs_static, MBPs_static, DBPs_static, SBPs_static, corrPwttHrs_static, ... 
    meanHR_static, meanPWTT_static, meanBP_static, varHR_static, varPWTT_static, varBP_static, ...
    corrPwttBpTotal_static, corrPwttHrTotal_static, corrBpHrTotal_static, figCorr] = computeAll(filePath, fileNames, '静止或改变姿态');
saveas(figCorr, [filePathForSave, '/静止或改变姿态：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/静止或改变姿态：PWTT与BP的相关性'], 'jpg');

%% 处理憋气测试集信号
fileNames = {'bq.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hx.mat', 'hs.mat'
[HRs_bq, PWTTs_bq, MBPs_bq, DBPs_bq, SBPs_bq, corrPwttHrs_bq, ... 
    meanHR_bq, meanPWTT_bq, meanBP_bq, varHR_bq, varPWTT_bq, varBP_bq, ...
    corrPwttBpTotal_bq, corrPwttHrTotal_bq, corrBpHrTotal_bq, figCorr] = computeAll(filePath, fileNames, '改变呼吸');
saveas(figCorr, [filePathForSave, '/改变呼吸：PWTT与BP的相关性'], 'fig');
set(figCorr, 'PaperPositionMode', 'auto');
saveas(figCorr, [filePathForSave, '/改变呼吸：PWTT与BP的相关性'], 'jpg');

%% 处理喝水测试集信号
fileNames = {'hs.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_hs, PWTTs_hs, MBPs_hs, DBPs_hs, SBPs_hs, corrPwttHrs_hs, ... 
    meanHR_hs, meanPWTT_hs, meanBP_hs, varHR_hs, varPWTT_hs, varBP_hs, ...
    corrPwttBpTotal_hs, corrPwttHrTotal_hs, corrBpHrTotal_hs, figCorr] = computeAll(filePath, fileNames, '喝水');
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
    (MBPs, PWTTs, MBPs_static, PWTTs_static, formulas, '静止或改变姿态');
saveas(figEst, [filePathForSave, '/静止或改变姿态：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/静止或改变姿态：标定后估计血压'], 'jpg');
% 用憋气数据验证
[MSEs_bq, MEs_bq, SVEs_bq, CORRs_bq, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
    (MBPs, PWTTs, MBPs_bq, PWTTs_bq, formulas, '改变呼吸');
saveas(figEst, [filePathForSave, '/改变呼吸：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/改变呼吸：标定后估计血压'], 'jpg');
% 用喝水数据验证
[MSEs_hs, MEs_hs, SVEs_hs, CORRs_hs, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
    (MBPs, PWTTs, MBPs_hs, PWTTs_hs, formulas, '喝水');
saveas(figEst, [filePathForSave, '/喝水：标定后估计血压'], 'fig');
set(figEst, 'PaperPositionMode', 'auto');
saveas(figEst, [filePathForSave, '/喝水：标定后估计血压'], 'jpg');

save([filePathForSave, '/results.mat']);
