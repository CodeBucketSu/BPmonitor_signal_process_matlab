function [HRs, PWTTs, MBPs, DBPs, SBPs, corrPwttHrs, meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computeAll(filePath, fileNames, needPlot, titleOfSignals)
% computeAll 函数从文件中读取原始数据，计算血压、心率，12种脉搏波传播时间各自的均值，标准差，以及他们之间的相关系数
% [HRs, PWTTs, MBPs, DBPs, SBPs, meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, corrPwttBp, corrPwttHr, corrBpHr] = computeAll(filePath, fileNames)
% 返回值： 
%   HRs：                1   x   lenEvents   每次测量事件对应的心率
%   PWTTs：              12  x   lenEvents   每次测量事件对应的传播时间
%   MBPs：               1   x   lenEvents   每次测量事件对应的平均压
%   SBPs：               1   x   lenEvents   每次测量事件对应的收缩压
%   DBPs：               1   x   lenEvents   每次测量事件对应的舒张压
%   corrPwttHrs：        12  x   lenEvents   每次测量事件对应的传播时间和心率的相关系数
%   meanHR：             1   x   1           心率的均值
%   meanPWTT：           12  x   1           传播时间的均值
%   meanBP：             1   x   1           血压的均值
%   varHR：              1   x   1           心率的标准差
%   varPWTT：            12  x   1           传播时间的标准差
%   varBP：              1   x   1           血压的标准差
%   corrPwttBpTotal：    12  x   1           传播时间和血压的相关系数
%   corrPwttHrTotal：    12  x   1           传播时间和心率的相关系数
%   corrBpHrTotal：      1   x   1           血压和心率的相关系数
% 输入：
%   filePath：   文件所在文件夹
%   fileNames：  包含了索要读取的文件的文件名的元胞数组


%% 计算血压测量事件的数量
lenEvents = 0;
events = {};
ecg = [];
for j = 1 : length(fileNames)
    load(fullfile(filePath, fileNames{j}));   
    lenEvent = length(events);
    for i = 1 : lenEvent
        event = events{i};
        if strcmp(event('Event'),  'FinishedMeasure') && length(event.keys()) == 4
            lenEvents = lenEvents + 1;
        end
    end
end

%% 初始化结果数组
HRs = zeros(1, lenEvents);      %每次测量时间对应的心率
PWTTs = zeros(12, lenEvents);   %每次测量事件对应的传播时间
MBPs = zeros(1, lenEvents);     %每次测量事件对应的平均压
SBPs = zeros(1, lenEvents);     %每次测量事件对应的收缩压
DBPs = zeros(1, lenEvents);     %每次测量事件对应的舒张压
corrPwttHrs = zeros(12, 1);      %传播时间和心率的相关系数
% 载入手臂处于：平放、下垂、上举 3种状态下测量的脉搏波和血压信号，并进行PWTTt的计算，
% 并将每个血压信号与对应的PWTTt均值保存下来用于标定
eventsCnt = 0;
for j = 1 : length(fileNames)
    load(fullfile(filePath, fileNames{j}));
    disp([filePath, 'file ', fileNames{j}, ': data loaded.'])
    
    lenEvent = length(events);
    for i = 1 : lenEvent
        event = events{i};
        if strcmp(event('Event'),  'StartMeasure')
            startTime = event('Time');
        end
        if strcmp(event('Event'),  'FinishedMeasure') && length(event.keys()) == 4
            endTime = event('Time');
            
            %% 读取收缩压、舒张压，并计算平均压
            BPsys = event('BPsys');
            BPdia = event('BPdia');
            
            %% 计算hr，用各种方式计算pwtt
            hasError = 0;
            figures = [];
            [PWTT_elbow_peak, PWTT_elbow_valley, PWTT_elbow_key, PWTT_elbow_rise, ~, fig, err] = ...
                computePWTwithECGandBP(ecg(startTime:endTime), bpElbow(startTime:endTime), ...
                needPlot, [titleOfSignals,' - Compute PWTT with ECG and BPelbow']);
            hasError = hasError || err;
            if (needPlot || err)
                figures(end + 1) = fig;
            end
            [PWTT_wrist_peak, PWTT_wrist_valley, PWTT_wrist_key, PWTT_wrist_rise, hr, fig, err] = ...
                computePWTwithECGandBP(ecg(startTime:endTime), bpWrist(startTime:endTime), ...
                needPlot, [titleOfSignals,' - Compute PWTT with ECG and BPwrist']);
            hasError = hasError || err;
            if (needPlot || err)
                figures(end + 1) = fig;
            end
            [PWTT_bps_peak, PWTT_bps_valley, PWTT_bps_key, PWTT_bps_rise, fig, err] = ...
                computePWTwithBPs(bpElbow(startTime:endTime), bpWrist(startTime:endTime), ...
                needPlot, [titleOfSignals,' - Compute PWTT with BPs']);
            hasError = hasError || err;
            if (needPlot || err)
                figures(end + 1) = fig;
            end
            
            %% 分别从手肘和手腕处的脉搏波中提取波形特征
            [features_elbow, featureNames_elbow]  = computeFeaturesWithPulseWave(bpElbow(startTime:endTime));
            if (needPlot || err)
                figures(end + 1) = plotPulseWaveFeatures(features_elbow, featureNames_elbow, titleOfSignals);
            end
            [features_wrist, featureNames_wrist]  = computeFeaturesWithPulseWave(bpWrist(startTime:endTime));
            if (needPlot || err)
                figures(end + 1) = plotPulseWaveFeatures(features_wrist, featureNames_wrist, titleOfSignals);
            end
            
            
            %% 计算每次测量事件对应的传播时间和心率的相关系数
            pwtts = {PWTT_elbow_peak; PWTT_elbow_valley; PWTT_elbow_key; PWTT_elbow_rise; ...
                PWTT_wrist_peak; PWTT_wrist_valley; PWTT_wrist_key; PWTT_wrist_rise;...
                PWTT_bps_peak; PWTT_bps_valley; PWTT_bps_key; PWTT_bps_rise};
            pwttNames = {'PWTT\_elbow\_peak', 'PWTT\_elbow\_valley', 'PWTT\_elbow\_key', 'PWTT\_elbow\_rise',...
                'PWTT\_wrist\_peak', 'PWTT\_wrist\_valley', 'PWTT\_wrist\_key', 'PWTT\_wrist\_rise', ...
                'PWTT\_bps\_peak', 'PWTT\_bps\_valley', 'PWTT\_bps\_key', 'PWTT\_bps\_rise'};
            
            [correlations, fig] = computePWTTCorrelationsWithHR(hr, pwtts, pwttNames, needPlot | hasError, titleOfSignals); 
            if (needPlot || hasError)
                figures(end + 1) = fig;
            end

            %% 让用户判定检测数据是否可用,仅当可用时才记录数据

            if ~hasError || (needPlot || hasError) && input('本次事件的数据检测是否可用？（是：1， 否：其他）') == 1 
                eventsCnt = eventsCnt + 1;
                %% 计录每次测量事件对应的传播时间和心率的相关系数
                corrPwttHrs(:, eventsCnt) = correlations;

                %% 记录每次测量事件对应的血压值
                BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %对平均压的简单估计
                MBPs(eventsCnt) = BPmean;
                SBPs(eventsCnt) = BPsys;
                DBPs(eventsCnt) = BPdia;

                %% 记录每次测量事件对应的传播时间
                PWTTs(:, eventsCnt) = computeMeanFeatures(pwtts);

                %% 记录每次测量事件对应的心率
                HRs(eventsCnt) = mean(hr(:, 2));
            end
            close(figures);
        end
    end
end
HRs = HRs(:, 1:eventsCnt);      %每次测量时间对应的心率
PWTTs = PWTTs(:, 1:eventsCnt);   %每次测量事件对应的传播时间
MBPs = MBPs(:, 1:eventsCnt);     %每次测量事件对应的平均压
SBPs = SBPs(:, 1:eventsCnt);     %每次测量事件对应的收缩压
DBPs = DBPs(:, 1:eventsCnt);     %每次测量事件对应的舒张压


%% 记录总的平均压的均值和标准差
meanBP = mean(MBPs);
varBP = std(MBPs);

%% 记录总的心率的均值和标准差
meanHR = mean(HRs); 
varHR = std(HRs); 
            
%% 记录总的传播时间的均值和标准差
meanPWTT = mean(PWTTs, 2);
varPWTT = (std(PWTTs.')).';


%% 计算12种pwtt和实测血压的相关性，计算12组CorrBpHr与心率的相关性， 计算血压与心率的相关性
[corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computePWTTCorrelationsWithBP(MBPs, PWTTs, pwttNames, HRs, mean(corrPwttHrs, 2), titleOfSignals);

end