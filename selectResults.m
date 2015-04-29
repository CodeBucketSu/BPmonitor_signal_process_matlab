function [corrs_good, pvals_good] = selectResults(corrs, pvals, ration, method)
% function [corrs_good, pvals_good] = selectResults(corrs, pvals)
% 根据相关性corrs和显著性pval筛选出较好的前ration%个结果
col = size(corrs, 2);
num2keep = ceil(col * ration);
num2keep = 7;
corrs_good = zeros(size(corrs, 1), num2keep);
pvals_good = zeros(size(pvals, 1), num2keep);

if strcmp(method, 'EACH_FEATURE')
    if size(corrs, 1) == 12
        [pvals_sort, pvals_idxs] = sort(corrs(11, :));        % 筛选PTT和血压关系
%         pvals_idxs = [15,23,21,16,24,13,14,2,11,3,10,8,25,9,7,26,17,6,5,18,19,1,12,4,22,20];                                       % 筛选PTT和心率关系
%         pavals_idx = [[21,23,15,11,24,2,14,16,3,5,1,13,8,25,7,20,6,10,17,4,9,12,26,22,18,19]];
%         pvals_idxs = ;                                       % 筛选PTT和心率关系
    else 
        [pvals_sort, pvals_idxs ] = sort(corrs(2, :));        % 筛选PWF和血压关系
%         [pvals_sort, pvals_idxs ] = sort(corrs(6, :));        % 筛选PWF和心率关系
%         pvals_idxs = [23,20,21,24,11,13,15,5,25,10,7,1,8,3,14,12,16,17,22,26,6,18,19,9,2,4];   
    end
%     [pvals_sort, pvals_idx] = sort(pvals, 2);
     pvals_idxs = [1, 3:8];
    for i = 1 : size(corrs, 1)  
%         idxs =  pvals_idx(i, 1 : num2keep);
        idxs = pvals_idxs(1:num2keep);
        corrs_good(i, :) = corrs(i, idxs);
%         pvals_good(i, :) = pvals(i, 1 : num2keep);
        pvals_good(i, :) = pvals(i, idxs);
    end
elseif strcmp(method, 'EACH_DATA')
    for i = 1 : size(corrs, 2)
        
    end
end

end