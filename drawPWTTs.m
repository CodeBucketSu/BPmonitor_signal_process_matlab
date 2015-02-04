function drawPWTTs(PWTTs, names)
% drawPWTTs(PWTTs, names)  ����PWTT
% PWTTs: PWTT��ɵ�Ԫ������
% names: PWTTs�ж�ӦPWTT��������ɵ�Ԫ������
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