function drawSignalPeaksAndPeaksUsed(signal, peaks, peaks_used, color)
% drawSignalPeaksAndPeaksUsed(signal, peaks, peaks_used, color)
% �����źţ��ؼ��㣬�Ͷ�Ӧ����ʹ�õĹؼ���
% signal���ź�
% peaks���ؼ���
% peaks_used����Ӧ�ı�ʹ�õĹؼ���
% peaks_name���ؼ����Ӧ������
% color����Ӧ����ɫ

markers = {'+', '*', '.', 'x', 's', 'd', 'p', 'h'};
plots = zeros(length(peaks) + 2);
hold on
plots(1) = plot(signal, 'k');
for i = 1 : length(peaks)
    peak = peaks{i};
    if length(peak) > 0
        plots(i+1) = plot(peak(:, 1), peak(:, 2), [color, markers{i}]);
    end
end

for i = 1 : length(peaks_used)
    peak = peaks_used{i};
    if length(peak) > 0
        plots(end) = plot(peak(:, 1), peak(:, 2), [color, 'o']);
    end
end

end