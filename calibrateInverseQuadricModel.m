function [parameters] = calibrateInverseQuadricModel(BPs, PWTTs)
% [parameters] = calibrateInverseQuadricModel(BPs, PWTTs) �궨MKģ�͵Ĳ���
% BP = p1 / PWTT + p2

inverseQuadPWTTs = 1/(PWTTs^2);
parameters = polyfit(inverseQuadPWTTs, BPs, 1);

end