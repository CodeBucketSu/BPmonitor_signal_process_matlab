function [parameters] = calibrateQuadModel(BPs, PWTTs)
% [parameters] = calibrateQuadModel(BPs, PWTTs) 标定MK模型的参数
% P = p1 * T^2 + p2 * T + p3

parameters = polyfit(PWTTs, BPs, 2);

end