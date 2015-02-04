clc, clear, close all;

%% open the files
% read the signal data
[sigFileName, filePath] = uigetfile('.uSig', 'choose the signal file.', 'D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\');
if isequal(sigFileName, 0)
    disp('User selected cancel')
    return  
end
disp(['file path: ', filePath])
disp(['signal file name: ', sigFileName])
[data,acc] = readSignal([filePath, sigFileName]);

% read the event data
eventFileName = [sigFileName(1:end - length('uSig')), 'uEvent'];
disp(['event file name: ', eventFileName]);
events = readEvent([filePath, eventFileName]);

%% filter the signals


%% display the signals and events
ecg = data(:, 3);
bpWrist = data(:, 1);
bpElbow = data(:, 2);
figure(), plot(1 : length(bpElbow), bpElbow, 'r', 1: length(bpElbow), bpWrist, 'g');
accX = acc(:, 1);
accY = acc(:, 2);
accZ = acc(:, 3);
len = length(ecg);
x = 1:len;
x = x.';
% 这幅图用于展示原始数据以供参考
figure(), hold on
plot(x(1:10:end), accX, 'r');
plot(x(1:10:end), accY + 500, 'g');
plot(x(1:10:end), accZ + 1000, 'b');
plot(x, ecg + 2000, 'r');
plot(x, bpElbow + 5000);
plot(x, bpWrist + 8000);
% 这幅图用于修改终点起点
figure(), hold on
plot(x(1:10:end), accX, 'r');
plot(x(1:10:end), accY + 500, 'g');
plot(x(1:10:end), accZ + 1000, 'b');
plot(x, ecg + 2000, 'r');
plot(x, bpElbow + 5000);
plot(x, bpWrist + 8000);

%% plot the current event point and adjust the end point
lenEvent = length(events);

for i = 1 : lenEvent
    event = events{i};
    if strcmp(event('Event'),  'StartMeasure')
        % 保存开始测量事件的原始信息
        currStartIdxInEvents = i;
        currStartEvent = event;
    end
    if strcmp(event('Event'),  'FinishedMeasure')
        % 保存测量完成事件的原始信息
        currEndIdxInEvents = i;
        currEndEvent = event;
        
        %% 显示原始信息
        currStartTime = currStartEvent('Time');
        plot([currStartTime, currStartTime], [0, 15000], 'c');
        currEndTime = currEndEvent('Time');
        plot([currEndTime, currEndTime], [0, 15000], 'm');
        xlim([currStartTime - 5000, currEndTime + 5000]);
        
        %% 开始调整起点和终点
        needAdjust = input('是否需要调整起点和终点？(1：是，0：否)');
        while needAdjust == 1
            %% 将事件的原始信息做一份拷贝，因为可能需要重新调整，所以不要覆盖原始信息
            newStartEvenmt = currStartEvent;
            currStartTime = newStartEvenmt('Time');
            newEndEvent = currEndEvent;
            currEndTime = newEndEvent('Time');
            xlim([currStartTime - 5000, currEndTime + 5000]);
            newStartTime = -1;
            in = input(['原始值为：', num2str(currStartTime), '| 请调整开始时间（保留原值请输0）：']);
            %% 调整起点
            while 1 < in
                plot([newStartTime, newStartTime], [0, 15000], 'w');
                newStartTime = in;
                if newStartTime < 0
                    newStartTime = 0;
                end
                plot([newStartTime, newStartTime], [0, 15000], 'k');
                if newStartTime < currStartTime
                    xlim([newStartTime - 5000, currEndTime + 5000]);
                end
                in = input(['当前值为：', num2str(newStartTime), '| 请调整开始时间（使用当前值请输1，保留原值请输0）：']);
            end
            if in == 1 && newStartTime >= 0
                plot([newStartTime, newStartTime], [0, 15000], 'r');
                newStartEvenmt('Time') = newStartTime;
                events(currStartIdxInEvents) = {newStartEvenmt};
                disp(['修改后的值为：', num2str(events{currStartIdxInEvents}('Time'))])
            end

           %% 调整终点
            newEndTime = -1;
            in = input(['原始值为：', num2str(currEndTime), '| 请调整结束时间（保留原值请输0）：']);
            while 1 < in
                plot([newEndTime, newEndTime], [0, 15000], 'w');
                newEndTime = in;
                if newEndTime > len
                    newEndTime = len;
                end
                plot([newEndTime, newEndTime], [0, 15000], 'k');
                if newEndTime > currEndTime
                    xlim([currStartTime - 5000, newEndTime + 5000]);
                end
                in = input(['当前值为：', num2str(newEndTime), '| 请调整结束时间（使用当前值请输1，保留原值请输0）：']);
            end
            if in == 1 && newEndTime >= 0
                plot([newEndTime, newEndTime], [0, 15000], 'r');
                newEndEvent('Time') = newEndTime;
                events(currEndIdxInEvents) = {newEndEvent};
                disp(['修改后的值为：', num2str(events{currEndIdxInEvents}('Time'))])
            end
            
            needAdjust = input('是否需要重新调整起点和终点？(1：是，0：否)');
        end

    end
end

%% save the data
[dataFileName ,filePath]=uiputfile('.mat','save the data into file.', [filePath, '\data']);
save([filePath, dataFileName], 'acc', 'bpElbow', 'bpWrist', 'ecg', 'events');