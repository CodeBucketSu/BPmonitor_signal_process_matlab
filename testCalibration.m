clc, clear, close all;

%% �����źţ�ȡ�����õ����ݶΣ����Ʋ���
% ѡȡ���������ļ���
[fileName, filePath] = uigetfile('*.mat', 'ѡ�����ֱ�ƽ��״̬�²���������.',...
    'D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data');

% ���ڱ���ȡ�����ı궨����
meanPWTTs = [];  %ƽ�������ٶ�
meanBPs = [];   %ƽ��Ѫѹ


load(fullfile(filePath, fileName));
bpdata = [];
lenEvent = length(events);
for i = 1 : lenEvent
    event = events{i};
    if strcmp(event('Event'),  'StartMeasure')
        startTime = event('Time');
    end
    if strcmp(event('Event'),  'FinishedMeasure')
        endTime = event('Time');
        % ��¼ƽ��ѹ
        BPsys = event('BPsys');
        BPdia = event('BPdia');
        bpdata(end+1, 1) = startTime;
        bpdata(end, 2) = endTime;
        bpdata(end, 3) = BPsys;
        bpdata(end, 4) = BPdia;
    end
end



%% ���б궨
params = calibrate(ecg, bpElbow, bpdata);

