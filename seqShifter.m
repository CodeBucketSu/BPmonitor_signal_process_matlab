function [ shiftedseq ] = seqShifter( seq,innum,operationum )
%SEQSHIFTER 对输入序列seq进行向右移位衰减
%   输入
%   seq [N*1]矩阵 待移位序列
%   innum 1*1 更新的数字
%   operationum 1*1 当前是第几次移位
%   输出
%   shiftedseq [N*1]矩阵 移位完成序列

shiftedseq=[];
if isempty(seq)
    return
end
seq = seq(:)';
n = length(seq);
if n == 3 && operationum>=n%目前只分析序列长度为3的情况
    shiftedseq = [ceil([innum,seq(1:end)]*[0.4,0.3,0.2,0.1]'),seq(1:end-1)];
else
    shiftedseq = [innum,seq(1:end-1)];
end
end

