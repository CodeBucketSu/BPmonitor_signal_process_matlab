function drawSignalPeaksAndPeaksUsed(signal, peaks, peaks_used, color)
% drawSignalPeaksAndPeaksUsed(signal, peaks, peaks_used, color)
% 绘制信号，关键点，和对应的已使用的关键点
% signal：信号
% peaks：关键点
% peaks_used：对应的被使用的关键点
% peaks_name：关键点对应的名字
% color：对应的颜色

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