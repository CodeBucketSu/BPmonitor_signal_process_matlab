clc, clear, close all
needPlot = 0;


%% ѡȡ���������ļ���
%[filePath] = uigetdir(['Y:\code\young\syl',...
[filePath] = uigetdir('D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young',... % for syl
    '��ѡ���������ڵ��ļ��У���ȷ�����ļ����´�����Ϊ��data���͡�result�����ļ��У�');
filePathForDate = [filePath, '/data'];
filePathForSave = [filePath, '/result'];
formulas = {'MK-MODEL', 'POWER', 'LINEAR', 'QUADRIC'};

%% �����˶�ǰ���ź�
fileNames = {'pf.mat'};  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '�궨����');
saveFigures(figures, filePathForSave, ...
    {'�궨���ݣ�PWTT��BP�������'; '�궨���ݣ�PWF_elbw��BP�������';  '�궨���ݣ�PWF_wrst��BP�������'});

%% �����˶�����Լ��ź�
% fileNames = {'ydh.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
% [HRs_ydh, BPs_ydh, PWTTs_ydh, PWFs_elb_ydh, PWFs_wrst_ydh, PWFnames_ydh, ...
%     PWTTstats_ydh, PWFstats_elb_ydh, PWFstat_wrst_ydh, corrBpHr_ydh, figures]...
%     = computeAll(filePathForDate, fileNames, needPlot, '��ֹ��ı���̬');
% saveFigures(figures, filePathForSave, ...
%     {'��ֹ��ı���̬��PWTT��BP�������'; '��ֹ��ı���̬��PWF_elbw��BP�������';  '��ֹ��ı���̬��PWF_wrst��BP�������'});

%% ����ֹ���ı���̬�����Լ��ź�
fileNames = {'static.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
[HRs_static, BPs_static, PWTTs_static, PWFs_elb_static, PWFs_wrst_static, PWFnames_static, ...
    PWTTstats_static, PWFstats_elb_static, PWFstat_wrst_static, corrBpHr_static, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '��ֹ��ı���̬');
saveFigures(figures, filePathForSave, ...
    {'��ֹ��ı���̬��PWTT��BP�������'; '��ֹ��ı���̬��PWF_elbw��BP�������';  '��ֹ��ı���̬��PWF_wrst��BP�������'});

% %% ����������Լ��ź�
% fileNames = {'bq.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hx.mat', 'hs.mat'
% [HRs_bq, PWTTs_bq, MBPs_bq, DBPs_bq, SBPs_bq, corrPwttHrs_bq, ... 
%     meanHR_bq, meanPWTT_bq, meanBP_bq, varHR_bq, varPWTT_bq, varBP_bq, ...
%     corrPwttBpTotal_bq, corrPwttHrTotal_bq, corrBpHrTotal_bq, figCorr, ...
%     features_elbow_bq, features_wrist_bq] = computeAll(filePathForDate, fileNames, needPlot, '�ı����');
% saveFigure(figCorr, filePathForSave, '�ı������PWTT��BP�������');
% 
% %% �����ˮ���Լ��ź�
% fileNames = {'hs.mat'};  %'static.mat', 'gesture.mat', 'gesture1.mat', 'bq_hs.mat', 'hs.mat'
% [HRs_hs, PWTTs_hs, MBPs_hs, DBPs_hs, SBPs_hs, corrPwttHrs_hs, ... 
%     meanHR_hs, meanPWTT_hs, meanBP_hs, varHR_hs, varPWTT_hs, varBP_hs, ...
%     corrPwttBpTotal_hs, corrPwttHrTotal_hs, corrBpHrTotal_hs, figCorr, ...
%     features_elbow_hs, features_wrist_hs] = computeAll(filePathForDate, fileNames, needPlot, '��ˮ');
% saveFigure(figCorr, filePathForSave, '��ˮ��PWTT��BP�������');

%% �궨����֤
% fig = figure('Name', ' �궨����'); 
% calibrateAndPlot(BPs(3, :), PWTTs(9, :), 'POWER');
% saveas(fig, [filePathForSave, '/�궨���ݣ��궨�����Ѫѹ'], 'fig');
% set(fig, 'PaperPositionMode', 'auto');
% saveas(fig, [filePathForSave, '/�궨���ݣ��궨�����Ѫѹ'], 'jpg');
%% �þ�ֹ������֤
% [MSEs_static, MEs_static, SVEs_static, CORRs_static, figEst] = calibrateAndComputeBPwithFeaturesAndDifferentModel...
%     (BPs(3, :), PWTTs, BPs_static(3, :), PWTTs_static, formulas, PWTTstats_static_static(:, 3), '��ֹ��ı���̬����PWTT����Ѫѹ');
% saveFigure(figCorr, filePathForSave, '��ֹ��ı���̬���궨�����Ѫѹ');

% [MSEs_static, MEs_static, SVEs_static, CORRs_static, figEst] = calibrateAndComputeBPwithFeaturesAndDifferentModel...
%     (BPs(3, :), PWFs_wrst, BPs_static(3, :), PWFs_wrst_static, formulas, PWFstat_wrst_static(:, 3), '��ֹ��ı���̬����PWF����Ѫѹ');

% % �ñ���������֤
% [MSEs_bq, MEs_bq, SVEs_bq, CORRs_bq, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
%     (MBPs, PWTTs, MBPs_bq, PWTTs_bq, formulas, mean(corrPwttHrs_bq, 2), '�ı����');
% saveFigure(figCorr, filePathForSave, '�ı�������궨�����Ѫѹ');
% % �ú�ˮ������֤
% [MSEs_hs, MEs_hs, SVEs_hs, CORRs_hs, figEst] = calibrateAndComputeBPwith12PWTTsAndDifferentModel...
%     (MBPs, PWTTs, MBPs_hs, PWTTs_hs, formulas, mean(corrPwttHrs_hs, 2), '��ˮ');
% saveFigure(figCorr, filePathForSave, '��ˮ���궨�����Ѫѹ');

save([filePathForSave, '/result.mat']);


