function [HRs, PWTTs, MBPs, DBPs, SBPs, corrPwttHrs, meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computeAll(filePath, fileNames, needPlot, titleOfSignals)
% computeAll �������ļ��ж�ȡԭʼ���ݣ�����Ѫѹ�����ʣ�12������������ʱ����Եľ�ֵ����׼��Լ�����֮������ϵ��
% [HRs, PWTTs, MBPs, DBPs, SBPs, meanHR, meanPWTT, meanBP, varHR, varPWTT, varBP, corrPwttBp, corrPwttHr, corrBpHr] = computeAll(filePath, fileNames)
% ����ֵ�� 
%   HRs��                1   x   lenEvents   ÿ�β����¼���Ӧ������
%   PWTTs��              12  x   lenEvents   ÿ�β����¼���Ӧ�Ĵ���ʱ��
%   MBPs��               1   x   lenEvents   ÿ�β����¼���Ӧ��ƽ��ѹ
%   SBPs��               1   x   lenEvents   ÿ�β����¼���Ӧ������ѹ
%   DBPs��               1   x   lenEvents   ÿ�β����¼���Ӧ������ѹ
%   corrPwttHrs��        12  x   lenEvents   ÿ�β����¼���Ӧ�Ĵ���ʱ������ʵ����ϵ��
%   meanHR��             1   x   1           ���ʵľ�ֵ
%   meanPWTT��           12  x   1           ����ʱ��ľ�ֵ
%   meanBP��             1   x   1           Ѫѹ�ľ�ֵ
%   varHR��              1   x   1           ���ʵı�׼��
%   varPWTT��            12  x   1           ����ʱ��ı�׼��
%   varBP��              1   x   1           Ѫѹ�ı�׼��
%   corrPwttBpTotal��    12  x   1           ����ʱ���Ѫѹ�����ϵ��
%   corrPwttHrTotal��    12  x   1           ����ʱ������ʵ����ϵ��
%   corrBpHrTotal��      1   x   1           Ѫѹ�����ʵ����ϵ��
% ���룺
%   filePath��   �ļ������ļ���
%   fileNames��  ��������Ҫ��ȡ���ļ����ļ�����Ԫ������


%% ����Ѫѹ�����¼�������
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

%% ��ʼ���������
HRs = zeros(1, lenEvents);      %ÿ�β���ʱ���Ӧ������
PWTTs = zeros(12, lenEvents);   %ÿ�β����¼���Ӧ�Ĵ���ʱ��
MBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ��ƽ��ѹ
SBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ������ѹ
DBPs = zeros(1, lenEvents);     %ÿ�β����¼���Ӧ������ѹ
corrPwttHrs = zeros(12, 1);      %����ʱ������ʵ����ϵ��
% �����ֱ۴��ڣ�ƽ�š��´����Ͼ� 3��״̬�²�������������Ѫѹ�źţ�������PWTTt�ļ��㣬
% ����ÿ��Ѫѹ�ź����Ӧ��PWTTt��ֵ�����������ڱ궨
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
            
            %% ��ȡ����ѹ������ѹ��������ƽ��ѹ
            BPsys = event('BPsys');
            BPdia = event('BPdia');
            
            %% ����hr���ø��ַ�ʽ����pwtt
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
            
            %% �ֱ����������󴦵�����������ȡ��������
            [features_elbow, featureNames_elbow]  = computeFeaturesWithPulseWave(bpElbow(startTime:endTime));
            if (needPlot || err)
                figures(end + 1) = plotPulseWaveFeatures(features_elbow, featureNames_elbow, titleOfSignals);
            end
            [features_wrist, featureNames_wrist]  = computeFeaturesWithPulseWave(bpWrist(startTime:endTime));
            if (needPlot || err)
                figures(end + 1) = plotPulseWaveFeatures(features_wrist, featureNames_wrist, titleOfSignals);
            end
            
            
            %% ����ÿ�β����¼���Ӧ�Ĵ���ʱ������ʵ����ϵ��
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

            %% ���û��ж���������Ƿ����,��������ʱ�ż�¼����

            if ~hasError || (needPlot || hasError) && input('�����¼������ݼ���Ƿ���ã����ǣ�1�� ��������') == 1 
                eventsCnt = eventsCnt + 1;
                %% ��¼ÿ�β����¼���Ӧ�Ĵ���ʱ������ʵ����ϵ��
                corrPwttHrs(:, eventsCnt) = correlations;

                %% ��¼ÿ�β����¼���Ӧ��Ѫѹֵ
                BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %��ƽ��ѹ�ļ򵥹���
                MBPs(eventsCnt) = BPmean;
                SBPs(eventsCnt) = BPsys;
                DBPs(eventsCnt) = BPdia;

                %% ��¼ÿ�β����¼���Ӧ�Ĵ���ʱ��
                PWTTs(:, eventsCnt) = computeMeanFeatures(pwtts);

                %% ��¼ÿ�β����¼���Ӧ������
                HRs(eventsCnt) = mean(hr(:, 2));
            end
            close(figures);
        end
    end
end
HRs = HRs(:, 1:eventsCnt);      %ÿ�β���ʱ���Ӧ������
PWTTs = PWTTs(:, 1:eventsCnt);   %ÿ�β����¼���Ӧ�Ĵ���ʱ��
MBPs = MBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ��ƽ��ѹ
SBPs = SBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ������ѹ
DBPs = DBPs(:, 1:eventsCnt);     %ÿ�β����¼���Ӧ������ѹ


%% ��¼�ܵ�ƽ��ѹ�ľ�ֵ�ͱ�׼��
meanBP = mean(MBPs);
varBP = std(MBPs);

%% ��¼�ܵ����ʵľ�ֵ�ͱ�׼��
meanHR = mean(HRs); 
varHR = std(HRs); 
            
%% ��¼�ܵĴ���ʱ��ľ�ֵ�ͱ�׼��
meanPWTT = mean(PWTTs, 2);
varPWTT = (std(PWTTs.')).';


%% ����12��pwtt��ʵ��Ѫѹ������ԣ�����12��CorrBpHr�����ʵ�����ԣ� ����Ѫѹ�����ʵ������
[corrPwttBpTotal, corrPwttHrTotal, corrBpHrTotal, figCorr] = computePWTTCorrelationsWithBP(MBPs, PWTTs, pwttNames, HRs, mean(corrPwttHrs, 2), titleOfSignals);

end