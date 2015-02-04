function drawPWTTs(PWTTs, names)
% drawPWTTs(PWTTs, names)  绘制PWTT
% PWTTs: PWTT组成的元胞数组
% names: PWTTs中对应PWTT的名称组成的元胞数组
hold on
plots = [];
colors = {'b', 'm', 'r', 'k', 'g', 'c'};
names_ploted = {};
for i = 1 : length(PWTTs)
    PWTT = PWTTs{i};
    if (~isempty(PWTT(:)))
        plots(end+1) = plot(PWTT(:, 1), PWTT(:, 2), colors{i});
        plot(PWTT(:, 1), PWTT(:, 2), ['*', colors{i}]);
        names_ploted{end+1} = names{i};
    end
end
legend(plots, names);