function [ BPmean ] = estimateMeanBPfromSysAndDia( BPsys, BPdia )
%ESTIMATEMEANBPFROMSYSANDDIA ��ƽ��ѹ�ļ򵥹���
%   Detailed explanation goes here
    BPmean = 1/3 * BPsys + 2/3 * BPdia;

end

