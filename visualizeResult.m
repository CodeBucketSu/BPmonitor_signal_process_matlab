function visualizeResult()
close all
[fileName, filePath] = uigetfile('D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\batch_result\resultWithAllKindOfBPs',... % for syl
    '请选择批处理结果文件。');
load([filePath, fileName]);
results = {result_dbp; result_sbp; result_mbp};
% results = {result};
meanCorrsPTT = [];
meanCorrsPWFelbw = [];
meanCorrsPWFwrst = [];
for i = 1 : length(results)
    [c1, c2, c3] = visualizeOneResult(results{i});
    meanCorrsPTT = [meanCorrsPTT, c1];
    meanCorrsPWFelbw = [meanCorrsPWFelbw, c2];
    meanCorrsPWFwrst = [meanCorrsPWFwrst, c3];
end
figure, barh(abs(meanCorrsPTT));
figure, barh(abs(meanCorrsPWFelbw));
figure, barh(abs(meanCorrsPWFwrst));
end



function [meanCorrsPTT, meanCorrsPWFelbw, meanCorrsPWFwrst] = visualizeOneResult(result)
numOfPWF = 35;
col = size(result, 2);
% 初始化PTT相关数据
PTT2BPcorr = zeros(12, col);
PTT2BPpval = zeros(12, col);
PTT2HRcorr = zeros(12, col);
PTT2HRpval = zeros(12, col);
% 初始化PWFelb相关数据
PWFelb2BPcorr = zeros(numOfPWF, col);
PWFelb2BPpval = zeros(numOfPWF, col);
PWFelb2HRcorr = zeros(numOfPWF, col);
PWFelb2HRpval = zeros(numOfPWF, col);
% 初始化PWFwrst相关数据
PWFwrst2BPcorr = zeros(numOfPWF, col);
PWFwrst2BPpval = zeros(numOfPWF, col);
PWFwrst2HRcorr = zeros(numOfPWF, col);
PWFwrst2HRpval = zeros(numOfPWF, col);

%% 拼装数据
for i = 1 : col
    % 拼装PTT相关数据
    PTT2BPcorr(:, i) = result{1, i};
    PTT2BPpval(:, i) = result{2, i};
    PTT2HRcorr(:, i) = result{3, i};
    PTT2HRpval(:, i) = result{4, i};
    % 拼装PWFelb相关数据
    PWFelb2BPcorr(:, i) = result{5, i};
    PWFelb2BPpval(:, i) = result{6, i};
    PWFelb2HRcorr(:, i) = result{7, i};
    PWFelb2HRpval(:, i) = result{8, i};
    % 拼装PWFwrst相关数据
    PWFwrst2BPcorr(:, i) = result{9, i};
    PWFwrst2BPpval(:, i) = result{10, i};
    PWFwrst2HRcorr(:, i) = result{11, i};
    PWFwrst2HRpval(:, i) = result{12, i};
end
corrs = {PTT2BPcorr, PTT2HRcorr, PWFelb2BPcorr, PWFelb2HRcorr, PWFwrst2BPcorr, PWFwrst2HRcorr};
pvals = {PTT2BPpval,  PTT2HRpval, PWFelb2BPpval, PWFelb2HRpval, PWFwrst2BPpval, PWFwrst2HRpval};
names = { 'PTT2BPcorr', 'PTT2HRcorr', 'PWFelb2BPcorr', 'PWFelb2HRcorr', 'PWFwrst2BPcorr', 'PWFwrst2HRcorr'};

for i = 1  : length(corrs)
    corr = corrs{i};
    pval = pvals{i};
    name = names{i};
    [corr, pval] = selectResults(corr, pval, 0.6, 'EACH_FEATURE');
    meanCorr = plotCorrResult(corr, pval, name);
    if i == 2
        meanCorrsPTT = meanCorr;
    elseif i == 4
        meanCorrsPWFelbw = meanCorr;
    else
        meanCorrsPWFwrst = meanCorr;
    end
    
end
% plotCorrResult(PTT2BPcorr, PTT2BPpval, 'PTT2BPcorr');
% plotCorrResult(PTT2HRcorr, PTT2HRpval, 'PTT2HRcorr');
% plotCorrResult(PWFelb2BPcorr, PWFelb2BPpval, 'PWFelb2BPcorr');
% plotCorrResult(PWFelb2HRcorr, PWFelb2HRpval, 'PWFelb2HRcorr');
% plotCorrResult(PWFwrst2BPcorr, PWFwrst2BPpval, 'PWFwrst2BPcorr');
% plotCorrResult(PWFwrst2HRcorr, PWFwrst2HRpval, 'PWFwrst2HRcorr');

end

function nums = countGoodCorr(corrs, pvals)
    meanCorrs = mean(corrs, 2);
    meanNegIdxs = meanCorrs < 0;
    corrs(meanNegIdxs, :) = corrs(meanNegIdxs, :) * -1;
    idx = (corrs > 0.6) .* (pvals < 0.05);
    nums = sum(idx, 2);
end

function signs = countSignCorr(corrs)
    posNum = sum(corrs > 0, 2);
    signs = {};
    for i = 1 : length(posNum)
        if posNum(i) > 11
            signs{end + 1} = '+';
        elseif posNum(i) < 4
            signs{end + 1} = '-';
        else
            signs{end + 1} = 'N/A';
        end
    end
end

function [meanCorr, figs] = plotCorrResult(corrs, pvals, figureName)
    nums = countGoodCorr(corrs, pvals);
    signs = countSignCorr(corrs);
    if size(corrs, 1) == 12
        selectIdxs = [1:3, 5:7, 9:12];
    else
        selectIdxs = [1, 3:6, 2, 14:15, 17, 19:21, 23, 25, 32:33, 34, 26, 27, 7:10, 11:13, 30:31, 34];
    end
    nums = nums(selectIdxs);
    signs = signs(selectIdxs);
    corrs = corrs(selectIdxs, :);
    pvals = pvals(selectIdxs, :);
    [r, c] = getSubplotsSize(size(corrs, 1));
    %% 绘制波动图
%     figwave = figure('Name', [figureName, ': corr wave'], 'Outerpos', get(0, 'ScreenSize'));
%     hold on;
%     
%     for i = 1 : size(corrs, 1)
%         subplot(r,c,i), hold on;
%         plot(corrs(i, :));
%         plot(pvals(i, :), 'r');
%         title(num2str(i));
%     end
    
    %% 绘制均值方差图
    figbar = figure('Name', [figureName, ': mean corr']);hold on;
    meanCorr = mean(corrs, 2);
    stdCorr = std(corrs, 0, 2);
    meanPval = mean(pvals, 2);
    stdPval = std(pvals, 0, 2);
    bar([meanCorr, meanPval]);
    errorbar(meanCorr, stdCorr,  'r.');
    
    corrStr = {};
    for i = 1 : length(meanCorr)
        corrStr{end+1, 1} = [num2str(meanCorr(i, 1), '%.2f'), char(177),...
            num2str(stdCorr(i, 1), '%.2f')];
    end
        
%     figs = [figwave, figbar];
end

