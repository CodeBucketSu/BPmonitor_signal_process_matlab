function [ shiftedseq ] = seqShifter( seq,innum,operationum )
%SEQSHIFTER ����������seq����������λ˥��
%   ����
%   seq [N*1]���� ����λ����
%   innum 1*1 ���µ�����
%   operationum 1*1 ��ǰ�ǵڼ�����λ
%   ���
%   shiftedseq [N*1]���� ��λ�������

shiftedseq=[];
if isempty(seq)
    return
end
seq = seq(:)';
n = length(seq);
if n == 3 && operationum>=n%Ŀǰֻ�������г���Ϊ3�����
    shiftedseq = [ceil([innum,seq(1:end)]*[0.4,0.3,0.2,0.1]'),seq(1:end-1)];
else
    shiftedseq = [innum,seq(1:end-1)];
end
end

