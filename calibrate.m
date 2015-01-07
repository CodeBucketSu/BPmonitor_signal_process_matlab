function params = calibrate(ecg, ppg, bpdata)
%CALIBRATE 函数用来标定pwtt和血压之间的关系，
%   ecg：心电信号
%   ppg：血氧信号
%   bpdata：测量的血压信号，N * 4的矩阵，N为测量的N组数据，每组数据包含4个值，依次为：开始时间，结束时间，收缩压，舒张压
    
% 计算脉搏波传播时间和心率
[PWTT, hr] = computePWTwithECGandBP(ecg, ppg);

% 用于保存取出来的标定数据
meanPWTTs = [];  %平均传播速度
meanBPs = [];   %平均血压

% 从bpdata中取出每组血压数据，计算相对应的脉搏波平均传播时间
for i = 1 : size(bpdata, 1)
    % 取出血压数据
    startTime = bpdata(i, 1);
    endTime = bpdata(i, 2);
    BPsys = bpdata(i, 3);
    BPdia = bpdata(i, 4);
    
    % 计算并保存平均压
    BPmean = estimateMeanBPfromSysAndDia(BPsys, BPdia); %对平均压的简单估计
    meanBPs(end + 1) = BPmean;
    
    % 计算并保存平均传播时间
    fitIdx = find((PWTT(:, 1) > startTime) .* (PWTT(:, 1) < endTime));
    pwttFit = PWTT(fitIdx, 2);
    meanPWTTs(end + 1) = mean(pwttFit);
    
end

%% 进行标定
figure(), plot(meanPWTTs, meanBPs, '*')
params = polyfit(meanPWTTs, meanBPs, 2);
newMeanBPs = polyval(params, meanPWTTs);
hold on, plot(meanPWTTs, newMeanBPs, 'or');

end