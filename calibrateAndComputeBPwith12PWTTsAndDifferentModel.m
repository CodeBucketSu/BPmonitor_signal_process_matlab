function [MSEs, MEs, SVEs, CORRs, fig] = calibrateAndComputeBPwith12PWTTsAndDifferentModel(MBP4cali, features4cali, MBP4est, features4est, formulas, corrPwttHrs, titleOfSignals)
% function [] = calibrateAndComputeBPwith12PWTTAndDifferentModel(MBP4cali, features4cali, MBP4est, features4est)
% 根据不同的公式，以及12种PWTT，分别对标定数据集进行标定，并对数据集进行验证
MSEs = zeros(12, length(formulas));
MEs = zeros(12, length(formulas));
SVEs = zeros(12, length(formulas));
CORRs = zeros(12, length(formulas));

fig = figure('Name', [titleOfSignals, ' - Calibrate And Compute BP with different PWTTs and models.'], ...
    'OuterPos',  get(0, 'ScreenSize'));
[row, col] = getSubplotsSize(size(features4cali, 1));
for i = 1 : size(features4cali, 1)
    subplot(row, col, i);
    [MSEs(i, :), MEs(i, :), SVEs(i, :), CORRs(i, :)] = calibrateAndComputeBPwithDifferentModel(MBP4cali, features4cali(i, :), MBP4est, features4est(i, :), corrPwttHrs(i), formulas);
    if i > 1
        legend('off');
    end
end
    
end

