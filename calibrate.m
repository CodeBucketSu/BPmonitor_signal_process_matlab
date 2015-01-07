function params = calibrate(ecg, ppg, bpdata)
%CALIBRATE ���������궨pwtt��Ѫѹ֮��Ĺ�ϵ��
%   ecg���ĵ��ź�
%   ppg��Ѫ���ź�
%   bpdata��������Ѫѹ�źţ�N * 4�ľ���NΪ������N�����ݣ�ÿ�����ݰ���4��ֵ������Ϊ����ʼʱ�䣬����ʱ�䣬����ѹ������ѹ
    
% ��������������ʱ�������
[PWTT, hr] = computePWTwithECGandBP(ecg, ppg);

% ���ڱ���ȡ�����ı궨����
meanPWTTs = [];  %ƽ�������ٶ�
meanBPs = [];   %ƽ��Ѫѹ

% ��bpdata��ȡ��ÿ��Ѫѹ���ݣ��������Ӧ��������ƽ������ʱ��
for i = 1 : size(bpdata, 1)
    % ȡ��Ѫѹ����
    startTime = bpdata(i, 1);
    endTime = bpdata(i, 2);
    BPsys = bpdata(i, 3);
    BPdia = bpdata(i, 4);
    
    % ���㲢����ƽ��ѹ
    BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %��ƽ��ѹ�ļ򵥹���
    meanBPs(end + 1) = BPmean;
    
    % ���㲢����ƽ������ʱ��
    fitIdx = find((PWTT(:, 1) > startTime) .* (PWTT(:, 1) < endTime));
    pwttFit = PWTT(fitIdx, 2);
    meanPWTTs(end + 1) = mean(pwttFit);
    
end

%% ���б궨
figure(), plot(meanPWTTs, meanBPs, '*')
params = polyfit(meanPWTTs, meanBPs, 2);
newMeanBPs = polyval(params, meanPWTTs);
hold on, plot(meanPWTTs, newMeanBPs, 'or');

end