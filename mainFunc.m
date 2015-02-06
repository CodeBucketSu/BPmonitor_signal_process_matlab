function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = mainFunc( directory,method )
%MAINFUNC ����ԭ����main�������������е��ã�ÿ�λ�ȡһ�ַ�����Ӧ��3����ؾ���
%   ����
%   directory �ַ������� �������ڵ�processedĿ¼
%   method �ַ������� "PEAK" "DISTANCE" "WAVELET" ��ȡ�ķ��� 

%% ѡȡ���������ļ���
filepath = directory;
filePathForDate = [filePath, '/data'];
filePathForSave = [filePath, '/result'];

%% �����˶�ǰ���ź�
fileNames = {'pf.mat', 'xc.mat' };  %'sj.mat', 'xc.mat','pf.mat', 'ydh.mat'
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForDate, fileNames, needPlot, '�궨����');
saveFigures(figures, filePathForSave, ...
    {'�궨���ݣ�PWTT��BP�������'; '�궨���ݣ�PWF_elbw��BP�������';  '�궨���ݣ�PWF_wrst��BP�������'});

save([filePathForSave, '/result.mat']);
end

