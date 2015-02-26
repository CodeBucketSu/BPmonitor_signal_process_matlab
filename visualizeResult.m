function visualizeResult()
close all
[fileName, filePath] = uigetfile('D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young\batch_result',... % for syl
    '请选择批处理结果文件。');
load([filePath, fileName]);
results = {result_dbp; result_sbp; result_mbp}
for i = 1 : length(results)
    visualizeOneResult(results{i});
end
end

function visualizeOneResult(result)
col = size(result, 2);
% 初始化PTT相关数据
PTT2BPcorr = zeros(12, col);
PTT2BPpval = zeros(12, col);
PTT2HRcorr = zeros(12, col);
PTT2HRpval = zeros(12, col);
% 初始化PWFelb相关数据
PWFelb2BPcorr = zeros(34, col);
PWFelb2BPpval = zeros(34, col);
PWFelb2HRcorr = zeros(34, col);
PWFelb2HRpval = zeros(34, col);
% 初始化PWFwrst相关数据
PWFwrst2BPcorr = zeros(34, col);
PWFwrst2BPpval = zeros(34, col);
PWFwrst2HRcorr = zeros(34, col);
PWFwrst2HRpval = zeros(34, col);

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
for i = 1 : 2 : length(corrs)
    corr = corrs{i};
    pval = pvals{i};
    name = names{i};
    [corr, pval] = selectResults(corr, pval, 0.6, 'EACH_FEATURE');
    plotCorrResult(corr, pval, name);
end
% plotCorrResult(PTT2BPcorr, PTT2BPpval, 'PTT2BPcorr');
% plotCorrResult(PTT2HRcorr, PTT2HRpval, 'PTT2HRcorr');
% plotCorrResult(PWFelb2BPcorr, PWFelb2BPpval, 'PWFelb2BPcorr');
% plotCorrResult(PWFelb2HRcorr, PWFelb2HRpval, 'PWFelb2HRcorr');
% plotCorrResult(PWFwrst2BPcorr, PWFwrst2BPpval, 'PWFwrst2BPcorr');
% plotCorrResult(PWFwrst2HRcorr, PWFwrst2HRpval, 'PWFwrst2HRcorr');

end

function nums = countGoodCorr(corrs, pvals)
    idx = (abs(corrs) > 0.6) .* (pvals < 0.05);
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

function figs = plotCorrResult(corrs, pvals, figureName)
    nums = countGoodCorr(corrs, pvals);
    signs = countSignCorr(corrs);
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

