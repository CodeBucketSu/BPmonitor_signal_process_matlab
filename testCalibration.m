clc, clear, close all;

%% 读入信号，取出可用的数据段，绘制波形
% 选取数据所在文件夹
[fileName, filePath] = uigetfile('*.mat', '选出出手臂平放状态下测量的数据.',...
    'D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data');

% 用于保存取出来的标定数据
meanPWTTs = [];  %平均传播速度
meanBPs = [];   %平均血压


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
        % 记录平均压
        BPsys = event('BPsys');
        BPdia = event('BPdia');
        bpdata(end+1, 1) = startTime;
        bpdata(end, 2) = endTime;
        bpdata(end, 3) = BPsys;
        bpdata(end, 4) = BPdia;
    end
end



%% 进行标定
params = calibrate(ecg, bpElbow, bpdata);

