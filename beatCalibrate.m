function [relationName, parameters] = beatCalibrate(PWTT, BP)
% calibrate ʹ�ò�ͬ�ı��ʽ��PWTT��BP���б궨��������õı��ʽ���Ƽ����Ӧ������

relationNames = {'linear', 'Quadratic', 'inverseRatio', ...
    'inverseQuadratic', 'M-K', 'power'};
RMSE

%% ���Թ�ϵ BP = p1 * PWTT + p2 


%% ���ι�ϵ BP = p1 * PWTT^2 + p2 * PWTT + p3

%% ��������ϵ BP = p1 * (1 / PWTT) + p2

%% ���η��ȹ��� BP = p1 * (1 / PWTT^2) + p3

%% M-K���� BP = p1 * (ln(PWTT)) + p2

%% ָ����ϵ BP = p1 * exp(p2 * PWTT)

end

