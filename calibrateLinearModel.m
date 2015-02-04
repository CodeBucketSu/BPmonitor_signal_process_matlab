function [parameters] = calibrateLinearModel(BPs, PWTTs)
% [parameters] = calibrateLinearModel(BPs, PWTTs) 标定MK模型的参数
% P = p1 * T + p2
parameters = polyfit(PWTTs, BPs, 1);

end