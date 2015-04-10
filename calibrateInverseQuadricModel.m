function [parameters] = calibrateInverseQuadricModel(BPs, PWTTs)
% [parameters] = calibrateInverseQuadricModel(BPs, PWTTs) 标定MK模型的参数
% BP = p1 / PWTT + p2

inverseQuadPWTTs = 1/(PWTTs^2);
parameters = polyfit(inverseQuadPWTTs, BPs, 1);

end