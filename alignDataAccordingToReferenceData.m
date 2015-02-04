function [dataAligned] = alignDataAccordingToReferenceData(src, ref, intervalLowerBound, intervalUpperBound)
% [dataAligned] = alignDataAccordingToReferenceData(src, ref)
% ������Ŀ��������ο����ݶ��룬���Ŀ��������û�кͲο������еĵ��Ӧ�ĵ㣬��õ���Ϊ[-1, 0]
% ���룺
%   src��    N x 2   Ŀ������
%   ref��    N x 2   �ο�����
%   intervalLowerBound��Ŀ�����ݺͲο����ݵ�ʱ����н�С��ֵ����������
%   intervalUpperBound��Ŀ�����ݺͲο����ݵ�ʱ����нϴ��ֵ����������
% ���ӣ�
%   [onsetsAligned] = alignDataAccordingToReferenceData(onsets, peaks, -300, -10)
%           onsets�ĺϷ�λ������peaks��ǰ300��ǰ10֮��
%   [dicNotchAligned] = alignDataAccordingToReferenceData(dicNotch, peaks, 100, 500)
%           onsets�ĺϷ�λ������peaks�ĺ�100����500֮��

lb = intervalLowerBound;
ub = intervalUpperBound;

%% ����1�������ʼ��
dataAligned = zeros(size(ref));

%% ����2��Ϊ�ο������е�ÿ����Ѱ�Ҷ�Ӧ��
j = 1;
lenRef = size(ref, 1);
lenSrc = size(src, 1);
for i = 1 : lenRef
    %% ��Ŀ���������ҵ���һ�����ܴ��ںϷ���Χ�ĵ�
    while j <= lenSrc && src(j, 1) < ref(i, 1) + lb
        j = j + 1;
    end % while
    %% Ŀ�������Ѿ���ȫ������ϣ�û���ҵ���Ӧ�ĵ�
    if j > lenSrc
        dataAligned(i, :) = [-1, 0];
    else
        %% �ж���ǰĿ����Ƿ��ںϷ���Χ��
        if src(j, 1) < ref(i, 1) + ub;
            dataAligned(i, :) = src(j, :);
        else
            dataAligned(i, :) = [-1, 0];
        end % if
    end % if
    
    
end % for


end % function