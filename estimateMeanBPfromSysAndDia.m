function [ BPmean ] = estimateMeanBPfromSysAndDia( BPsys, BPdia )
%ESTIMATEMEANBPFROMSYSANDDIA 对平均压的简单估计
%   Detailed explanation goes here
    BPmean = 1/3 * BPsys + 2/3 * BPdia;

end

