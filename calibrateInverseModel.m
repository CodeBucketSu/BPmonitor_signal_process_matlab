function [parameters] = calibrateInverseModel(BPs, PWTTs)
% [parameters] = calibrateInverseModel(BPs, PWTTs) �궨MKģ�͵Ĳ���
% BP = p1 / PWTT + p2

inversePWTTs = 1./PWTTs;
parameters = polyfit(inversePWTTs, BPs, 1);

end