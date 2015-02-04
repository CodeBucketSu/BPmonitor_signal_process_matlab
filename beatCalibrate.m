function [relationName, parameters] = beatCalibrate(PWTT, BP)
% calibrate 使用不同的表达式对PWTT和BP进行标定，返回最好的表达式名称及其对应参数。

relationNames = {'linear', 'Quadratic', 'inverseRatio', ...
    'inverseQuadratic', 'M-K', 'power'};
RMSE

%% 线性关系 BP = p1 * PWTT + p2 


%% 二次关系 BP = p1 * PWTT^2 + p2 * PWTT + p3

%% 反比例关系 BP = p1 * (1 / PWTT) + p2

%% 二次反比管理 BP = p1 * (1 / PWTT^2) + p3

%% M-K方程 BP = p1 * (ln(PWTT)) + p2

%% 指数关系 BP = p1 * exp(p2 * PWTT)

end

