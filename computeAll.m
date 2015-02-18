function [HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePath, fileNames, needPlot, titleOfSignals) 
% computeAll �������ļ��ж�ȡԭʼ���ݣ�����Ѫѹ�����ʣ�12������������ʱ�䣬2·���������Ե��������Լ�����������ͳ����
% [HRs, BPs, PWTTs, PWF_elb, PWF_wrst, PWTTstats, PWFnames, PWFstats_elb, PWFstat_wrst, figure]...
%    = computeAll(filePath, fileNames, needPlot, titleOfSignals) 
%
% OUTPUT�� 
%   HRs��                1   x   lenEvents   ÿ�β����¼���Ӧ������
%   BPs��                3   x   lenEvents   ÿ�β���ʱ���Ӧ��Ѫѹ��˳��Ϊ������ѹ������ѹ��ƽ��ѹ
%   PWTTs��              12  x   lenEvents   ÿ�β����¼���Ӧ�Ĵ���ʱ��
%   PWFs_elb��           K   x   lenEvents   ÿ�β����¼���Ӧ����������������ֵ��KΪ����ֵ�������             
%   PWFs_wrst��          K   x   lenEvents   ÿ�β����¼���Ӧ����������������ֵ��KΪ����ֵ�������
%   PWFnames��           K   x   1           ����������ֵ���ƣ�Ԫ������
%   PWTTstats��          12  x   3           PWTT��ͳ��ֵ��
%                                               ƽ��PWTT��Ѫѹ�������
%                                               ƽ��PWTT��ƽ��HR�������
%                                               ����PWTT������HR������Եľ�ֵ
%   PWFstats_elb��       K   x   3           ����������������ͳ��ֵ��
%                                               ƽ��PWF��Ѫѹ�������
%                                               ƽ��PWF��ƽ��HR�������
%                                               ����PWF������HR������Եľ�ֵ
%   PWFstat_wrst��       K   x   3           ����������������ͳ��ֵ��
%                                               ƽ��PWF��Ѫѹ�������
%                                               ƽ��PWF��ƽ��HR�������
%                                               ����PWF������HR������Եľ�ֵ
%   figures��            L   x   1           �����л��Ƶ�ͼ�Σ�LΪͼ�θ�����Ԫ������
%   figureNames��        L   x   1           �����л��Ƶ�ͼ�ζ�Ӧ�����ڱ�������֣�Ԫ������
%
% INPUT��
%   filePath��                               �ļ������ļ���
%   fileNames��                              ��������Ҫ��ȡ���ļ����ļ�����Ԫ������
%   needPlot��                               �Ƿ���Ҫ��ӡ�ؼ�������
%   titleOfSignals��                         ��ͼʱ���õı���


%% ����Ѫѹ�����¼�������
lenEvents = calculateLengthOfEvents(filePath, fileNames);

%% ��ʼ���������
ecg = [];                       %�������ecg����ʼ����matlab����Ϊ����һ��ϵͳ����ecg
events = {};
HRs = zeros(1, lenEvents);      %ÿ�β���ʱ���Ӧ������
PWTTs = zeros(12, lenEvents);   %ÿ�β����¼���Ӧ�Ĵ���ʱ��
MBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ��ƽ��ѹ
SBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ������ѹ
DBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ������ѹ
corrPwttHrs = zeros(12, 1);     %����ʱ������ʵ����ϵ��
PWFs_elb = [];         %��������������
PWFs_wrst = [];         %��������������
figures = [];


%% �����������������Ѫѹ�źţ��������������㣬
% ����ÿ��Ѫѹ�ź����Ӧ��PWTTt��ֵ�����������ڱ궨
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
            
            %% ����1����ȡ����ѹ������ѹ��������ƽ��ѹ
            BPsys = event('BPsys');
            BPdia = event('BPdia');
            
            %% ����2������HR����ͬ��PWTT,�Լ�����PWF
            [hr, pwtts, pwttNames, pwfs_elbw, pwfs_wrist, PWFnames, figuresToClose, hasError] = ...
                computeAllFeaturesFromOneMeasureEvent(ecg(startTime : endTime), ...
                bpElbow(startTime : endTime), bpWrist(startTime : endTime), needPlot, titleOfSignals);

            %% ����ÿ�β����¼���Ӧ�ĸ������������ʵ����ϵ��
            [corrPwtt2Hr, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwtts, pwttNames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);
            [corrFtr2HrElb, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwfs_elbw, PWFnames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);
            [corrFtr2HrWrst, fig] = computeCorrelationsBetweenFeatureAndHRFromOneMeasureEvent(hr, pwfs_wrist, PWFnames, needPlot | hasError, titleOfSignals); 
            figuresToClose = recordFeatureIfNeeded(figuresToClose, fig, needPlot || hasError);

            %% ��Ҫʱ���û��ж���������Ƿ����,��������ʱ�ż�¼����
            if ~hasError || (needPlot || hasError) && input('�����¼������ݼ���Ƿ���ã����ǣ�1�� ��������') == 1 
%            if ~hasError || (needPlot || hasError) 
%            if ~hasError
                eventsCnt = eventsCnt + 1;
                
                %% ��¼ÿ�β����¼���Ӧ�ĸ������������ʵ����ϵ��
                corrPwttHrs(:, eventsCnt) = corrPwtt2Hr;
                corrFtrHrs_elbw(:, eventsCnt) = corrFtr2HrElb;
                corrFtrHrs_wrst(:, eventsCnt) = corrFtr2HrWrst;

                %% ��¼ÿ�β����¼���Ӧ��Ѫѹֵ
                BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %��ƽ��ѹ�ļ򵥹���
                MBPs(eventsCnt) = BPmean;
                SBPs(eventsCnt) = BPsys;
                DBPs(eventsCnt) = BPdia;

                %% ��¼ÿ�β����¼���Ӧ�Ĵ���ʱ��
                PWTTs(:, eventsCnt) = computeMeanFeatures(pwtts);
                
                %% ��¼ÿ�β����¼���Ӧ��������������
                PWFs_elb(:, eventsCnt) = computeMeanFeatures(pwfs_elbw);
                PWFs_wrst(:, eventsCnt) = computeMeanFeatures(pwfs_wrist);

                %% ��¼ÿ�β����¼���Ӧ������
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
%% ��ȡ��Ч������
HRs = HRs(:, 1:eventsCnt);      %ÿ�β���ʱ���Ӧ������
PWTTs = PWTTs(:, 1:eventsCnt);   %ÿ�β����¼���Ӧ�Ĵ���ʱ��
MBPs = MBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ��ƽ��ѹ
SBPs = SBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ������ѹ
DBPs = DBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ������ѹ

%% ����12��pwtt��ʵ��Ѫѹ������ԣ�����12��CorrBpHr�����ʵ�����ԣ� ����Ѫѹ�����ʵ������
[corrPwttBp, corrPwttHr, corrBpHr, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWTTs, pwttNames, HRs, mean(corrPwttHrs, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);
[corrPwfBp_elbw, corrPwfHr_elbw, ~, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWFs_elb, PWFnames, HRs, mean(corrFtrHrs_elbw, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);
[corrPwfBp_wrst, corrPwfHr_wrst, ~, figCorr] = computeCorrelationsBetweenFeatureAndBP(MBPs, PWFs_wrst, PWFnames, HRs, mean(corrFtrHrs_wrst, 2), titleOfSignals);
figures = recordFeatureIfNeeded(figures, figCorr, 1);

%% ��װ��������ֵ
% ��װѪѹֵ
BPs = [MBPs; SBPs; DBPs];
% ��װPWTTͳ��ֵ
PWTTstats = zeros(12, 3);
PWTTstats(:, 1:2) = corrPwttBp;
PWTTstats(:, 3:4) = corrPwttHr;
PWTTstats(:, 5) = mean(corrPwttHrs, 2);
% ��װ����PWFͳ��ֵ
PWFstats_elb = zeros(length(corrPwfBp_elbw), 3);
PWFstats_elb(:, 1:2) = corrPwfBp_elbw;
PWFstats_elb(:, 3:4) = corrPwfHr_elbw; 
PWFstats_elb(:, 5) = mean(corrFtrHrs_elbw, 2); 
% ��װ����PWFͳ��ֵ
PWFstat_wrst = zeros(length(corrPwfBp_wrst), 3);
PWFstat_wrst(:, 1:2) = corrPwfBp_wrst;
PWFstat_wrst(:, 3:4) = corrPwfHr_wrst; 
PWFstat_wrst(:, 5) = mean(corrFtrHrs_wrst, 2); 

end

%% ����Ϊ�Ӻ���

function lenEvents = calculateLengthOfEvents(filePath, fileNames)
% ������ЧѪѹ�����¼�������
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
% �ж��Ƿ��ǿ�ʼ����Ѫѹ���¼�
    bool = strcmp(event('Event'),  'StartMeasure');
end

function bool = isValidEndMeasureEvent(event)
% �ж��Ƿ�����Ч����ɲ���Ѫѹ���¼�
    bool = strcmp(event('Event'),  'FinishedMeasure') && length(event.keys()) == 4;
end
