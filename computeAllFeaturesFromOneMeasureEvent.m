function [HR, PWTTs, PWTTnames, PWFs_elbw, PWFs_wrist, PWFnames, figures, hasError] = ...
    computeAllFeaturesFromOneMeasureEvent(ecg, pwElbow, pwWrist, needPlot, titleOfSignals)
% [PWTTs, PWFs_elbw, PWFs_wrist, figures, hasErr] = ...
%    computeAllFeatures(ecg, pwElbw, pwWrst, needPlot, titleOfSignals)
% �������������������������������ٶȣ�������������������������

hasError = 0;
figures = [];

%% �������ൽ�����PWTT
[PWTT_elbow_peak, PWTT_elbow_valley, PWTT_elbow_key, PWTT_elbow_rise, ~, fig, err] = ...
    computePWTwithECGandBP(ecg, pwElbow, ...
    needPlot, [titleOfSignals,' - Compute PWTT with ECG and pwElbow']);
hasError = hasError || err;
figures = recordFeatureIfNeeded(figures, fig, needPlot || hasError);

%% �������ൽ�����PWTT
[PWTT_wrist_peak, PWTT_wrist_valley, PWTT_wrist_key, PWTT_wrist_rise, HR, fig, err] = ...
    computePWTwithECGandBP(ecg, pwWrist, ...
    needPlot, [titleOfSignals,' - Compute PWTT with ECG and pwWrist']);
hasError = hasError || err;
figures = recordFeatureIfNeeded(figures, fig, needPlot || hasError);

%% �������⵽�ֲ���PWTT
[PWTT_bps_peak, PWTT_bps_valley, PWTT_bps_key, PWTT_bps_rise, fig, err] = ...
    computePWTwithBPs(pwElbow, pwWrist, ...
    needPlot, [titleOfSignals,' - Compute PWTT with BPs']);
hasError = hasError || err;
figures = recordFeatureIfNeeded(figures, fig, needPlot || hasError);

%% ��װ12��PWTT
PWTTs = {PWTT_elbow_peak; PWTT_elbow_valley; PWTT_elbow_key; PWTT_elbow_rise; ...
    PWTT_wrist_peak; PWTT_wrist_valley; PWTT_wrist_key; PWTT_wrist_rise;...
    PWTT_bps_peak; PWTT_bps_valley; PWTT_bps_key; PWTT_bps_rise};
PWTTnames = {'PWTT\_elbow\_peak', 'PWTT\_elbow\_valley', 'PWTT\_elbow\_key', 'PWTT\_elbow\_rise',...
    'PWTT\_wrist\_peak', 'PWTT\_wrist\_valley', 'PWTT\_wrist\_key', 'PWTT\_wrist\_rise', ...
    'PWTT\_bps\_peak', 'PWTT\_bps\_valley', 'PWTT\_bps\_key', 'PWTT\_bps\_rise'};

%% �ֱ����������󴦵�����������ȡ��������
[PWFs_elbw, PWFnames]  = computeFeaturesWithPulseWave(pwElbow);
if (needPlot || hasError)
    figures(end + 1) = plotPulseWaveFeatures(PWFs_elbw, PWFnames, titleOfSignals);
end
[PWFs_wrist, PWFnames]  = computeFeaturesWithPulseWave(pwWrist);
if (needPlot || hasError)
    figures(end + 1) = plotPulseWaveFeatures(PWFs_wrist, PWFnames, titleOfSignals);
end

end


function figures = recordFeatureIfNeeded(figs, fig, ifNeeded)
    if ifNeeded
        figures = [figs(:); fig];
    else
        figures = figs;
    end
end