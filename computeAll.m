function [HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePath, fileNames, needPlot, titleOfSignals) 
% computeAll 函数从文件中读取原始数据，计算血压、心率，12种脉搏波传播时间，2路脉搏波各自的特征，以及各种特征的统计量
% [HRs, BPs, PWTTs, PWF_elb, PWF_wrst, PWTTstats, PWFnames, PWFstats_elb, PWFstat_wrst, figure]...
%    = computeAll(filePath, fileNames, needPlot, titleOfSignals) 
%
% OUTPUT： 
%   HRs：                1   x   lenEvents   每次测量事件对应的心率
%   BPs：                3   x   lenEvents   每次测量时间对应的血压，顺序为：收缩压，舒张压，平均压
%   PWTTs：              12  x   lenEvents   每次测量事件对应的传播时间
%   PWFs_elb：           K   x   lenEvents   每次测量事件对应的手肘脉搏波特征值，K为特征值种类个数             
%   PWFs_wrst：          K   x   lenEvents   每次测量事件对应的手碗脉搏波特征值，K为特征值种类个数
%   PWFnames：           K   x   1           脉搏波特征值名称，元胞数组
%   PWTTstats：          12  x   3           PWTT的统计值：
%                                               平均PWTT和血压的相关性
%                                               平均PWTT和平均HR的相关性
%                                               逐拍PWTT和逐拍HR的相关性的均值
%   PWFstats_elb：       K   x   3           手肘脉搏波特征的统计值：
%                                               平均PWF和血压的相关性
%                                               平均PWF和平均HR的相关性
%                                               逐拍PWF和逐拍HR的相关性的均值
%   PWFstat_wrst：       K   x   3           手腕脉搏波特征的统计值：
%                                               平均PWF和血压的相关性
%                                               平均PWF和平均HR的相关性
%                                               逐拍PWF和逐拍HR的相关性的均值
%   figures：            L   x   1           方法中绘制的图形，L为图形个数，元胞数组
%   figureNames：        L   x   1           方法中绘制的图形对应的用于保存的名字，元胞数组
%
% INPUT：
%   filePath：                               文件所在文件夹
%   fileNames：                              包含了索要读取的文件的文件名的元胞数组
%   needPlot：                               是否需要打印关键点检测结果
%   titleOfSignals：                         绘图时所用的标题


%% 计算血压测量事件的数量
lenEvents = calculateLengthOfEvents(filePath, fileNames);

%% 初始化结果数组
ecg = [];                       %如果不对ecg做初始化，matlab会认为这是一个系统函数ecg
events = {};
HRs = zeros(1, lenEvents);      %每次测量时间对应的心率
PWTTs = zeros(12, lenEvents);   %每次测量事件对应的传播时间
MBPs = zeros(1, lenEvents);     %每次测量事件对应的平均压
SBPs = zeros(1, lenEvents);     %每次测量事件对应的收缩压
DBPs = zeros(1, lenEvents);     %每次测量事件对应的舒张压
corrPwttHrs = zeros(12, 1);     %传播时间和心率的相关系数
PWFs_elb = [];         %手肘脉搏波特征
PWFs_wrst = [];         %手腕脉搏波特征
figures = [];


%% 载入测量的脉搏波和血压信号，并进行特征计算，
% 并将每个血压信号与对应的PWTTt均值保存下来用于标定
eventsCnt = 0;
for j = 1 : length(fileNames)
    load(fullfile(filePath, fileNames{j}));
    disp([filePath, 'file ', fileNames{j}, ': data loaded.'])
    
    lenEvent = length(events);
    for i = 1 : lenEvent
        event = events{i};
        if isStartMeasureEvent(event)
            startTime = event('Time');
        end
        
        if isValidEndMeasureEvent(event)
            endTime = event('Time');
            
            %% 步骤1：读取收缩压、舒张压，并计算平均压
            BPsys = event('BPsys');
            BPdia = event('BPdia');
            
            %% 步骤2：计算HR，不同的PWTT,以及各种PWF
            [hr, pwtts, pwttNames, pwfs_elbw, pwfs_wrist, PWFnames, figuresToClose, hasError] = ...
                computeAllFeaturesFromOneMeasureEvent(ecg(startTime : endTime), ...
                bpElbow(startTime : endTime), bpWrist(startTime : endTime), needPlot, titleOfSignals);

            %% 计算每次测量事件对应的各种特征和心率的相关系数
            [corrPwtt2Hr, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwtts, pwttNames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);
            [corrFtr2HrElb, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwfs_elbw, PWFnames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);
            [corrFtr2HrWrst, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwfs_wrist, PWFnames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);

            %% 必要时让用户判定检测数据是否可用,仅当可用时才记录数据
            if ~hasError || (needPlot || hasError) && input('本次事件的数据检测是否可用？（是：1， 否：其他）') == 1 
%            if ~hasError || (needPlot || hasError) 
%            if ~hasError
                eventsCnt = eventsCnt + 1;
                
                %% 计录每次测量事件对应的各种特征和心率的相关系数
                corrPwttHrs(:, eventsCnt) = corrPwtt2Hr;
                corrFtrHrs_elbw(:, eventsCnt) = corrFtr2HrElb;
                corrFtrHrs_wrst(:, eventsCnt) = corrFtr2HrWrst;

                %% 记录每次测量事件对应的血压值
                BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %对平均压的简单估计
                MBPs(eventsCnt) = BPmean;
                SBPs(eventsCnt) = BPsys;
                DBPs(eventsCnt) = BPdia;

                %% 记录每次测量事件对应的传播时间
                PWTTs(:, eventsCnt) = computeMeanFeatures(pwtts);
                
                %% 记录每次测量事件对应的脉搏波的特征
                PWFs_elb(:, eventsCnt) = computeMeanFeatures(pwfs_elbw);
                PWFs_wrst(:, eventsCnt) = computeMeanFeatures(pwfs_wrist);

                %% 记录每次测量事件对应的心率
                HRs(eventsCnt) = mean(hr(:, 2));
            end
            close(figuresToClose);
        end
    end
end
if ~exist('corrFtrHrs_elbw','var')
    corrFtrHrs_elbw = zeros(size(PWFnames(:),2),5);
    corrFtrHrs_wrst = zeros(size(PWFnames(:),2),5);
end
%% 截取有效的数据
HRs = HRs(:, 1:eventsCnt);      %每次测量时间对应的心率
PWTTs = PWTTs(:, 1:eventsCnt);   %每次测量事件对应的传播时间
MBPs = MBPs(:, 1:eventsCnt);     %每次测量事件对应的平均压
SBPs = SBPs(:, 1:eventsCnt);     %每次测量事件对应的收缩压
DBPs = DBPs(:, 1:eventsCnt);     %每次测量事件对应的舒张压

%% 计算12种pwtt和实测血压的相关性，计算12组CorrBpHr与心率的相关性， 计算血压与心率的相关性
[corrPwttBp, corrPwttHr, corrBpHr, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWTTs, pwttNames, HRs, mean(corrPwttHrs, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);
[corrPwfBp_elbw, corrPwfHr_elbw, ~, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWFs_elb, PWFnames, HRs, mean(corrFtrHrs_elbw, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);
[corrPwfBp_wrst, corrPwfHr_wrst, ~, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWFs_wrst, PWFnames, HRs, mean(corrFtrHrs_wrst, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);

%% 封装函数返回值
% 封装血压值
BPs = [MBPs; SBPs; DBPs];
% 封装PWTT统计值
PWTTstats = zeros(12, 3);
PWTTstats(:, 1:2) = corrPwttBp;
PWTTstats(:, 3:4) = corrPwttHr;
PWTTstats(:, 5) = mean(corrPwttHrs, 2);
% 封装手肘PWF统计值
PWFstats_elb = zeros(length(corrPwfBp_elbw), 3);
PWFstats_elb(:, 1:2) = corrPwfBp_elbw;
PWFstats_elb(:, 3:4) = corrPwfHr_elbw; 
PWFstats_elb(:, 5) = mean(corrFtrHrs_elbw, 2); 
% 封装手腕PWF统计值
PWFstat_wrst = zeros(length(corrPwfBp_wrst), 3);
PWFstat_wrst(:, 1:2) = corrPwfBp_wrst;
PWFstat_wrst(:, 3:4) = corrPwfHr_wrst; 
PWFstat_wrst(:, 5) = mean(corrFtrHrs_wrst, 2); 

end

%% 以下为子函数

function lenEvents = calculateLengthOfEvents(filePath, fileNames)
% 计算有效血压测量事件的数量
    lenEvents = 0;
    events = {};
    for j = 1 : length(fileNames)
        load(fullfile(filePath, fileNames{j}));   
        lenEvent = length(events);
        for i = 1 : lenEvent
            event = events{i};
            if isValidEndMeasureEvent(event)
                lenEvents = lenEvents + 1;
            end
        end
    end
end

function bool = isStartMeasureEvent(event) 
% 判断是否是开始测量血压的事件
    bool = strcmp(event('Event'),  'StartMeasure');
end

function bool = isValidEndMeasureEvent(event)
% 判断是否是有效的完成测量血压的事件
    bool = strcmp(event('Event'),  'FinishedMeasure') && length(event.keys()) == 4;
end
