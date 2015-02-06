function [ pwfstat_best, methodNum ] = chooseMethod( pwfstats )
% [ pwfstat_best ] = chooseMethod( pwfstat_peak, pwfstat_distance, pwfstat_wavelet )
% �����ּ��㽵��Ͽ���ز����ķ����г����Ľ������ѡһ�������ݵ� 3,4,5,6,26,30,32,33 ����������ѡ��
% ���룺���ַ�������õ��Ľ��
% �������ѡ�ķ�����Ӧ�Ľ���ͷ���

IDXS2CMP = [3,4,5,6,26,30,32,33];

points = zeros(3, 1);

for i = 1 : length(IDXS2CMP)
    idx = IDXS2CMP(i);
    points = points + compareFeatureCorr({pwfstats{1}(idx, :), ...
         pwfstats{2}(idx, :), pwfstats{3}(idx, :)});
end

methodNum = find(points == max(points(:)), 1, 'first');
pwfstat_best = pwfstats{methodNum};

end

