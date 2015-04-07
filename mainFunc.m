function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = mainFunc( method,dataType,path )
%MAINFUNC ����ԭ����main�������������е��ã�ÿ�λ�ȡһ�ַ�����Ӧ��3����ؾ���
%   ����
%   method �ַ������� "PEAK" "DISTANCE" "WAVELET" ��ȡ�ķ��� 
%   dataType �ַ������� "CALIBRITION" "EXERCISE" "STATIC"
%   path �ַ������� �������ڵ�processedĿ¼

%%Ԥ����
needPlot = 0;
save('method.mat','method');
% ��Щ�����
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

%% ѡȡ���������ļ���
filePathForData = [path, '/data'];
filePathForSave = [path, '/result'];

%% �����ź�
fileNames = getFileNamesforBatch(candidates,filePathForData); 
if isempty(fileNames)
    return
end
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForData, fileNames, needPlot, '�궨����');
% saveFigures(figures, filePathForSave, ...
%     {'�궨���ݣ�PWTT��BP�������'; '�궨���ݣ�PWF_elbw��BP�������';  '�궨���ݣ�PWF_wrst��BP�������'});

save([filePathForSave, fileNameforSave]);
%%����
pwttcorr = PWTTstats;
pwfcorrelb = PWFstats_elb;
pwfcorrwrt = PWFstat_wrst;

end

