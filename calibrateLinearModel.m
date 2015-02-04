function [parameters] = calibrateLinearModel(BPs, PWTTs)
% [parameters] = calibrateLinearModel(BPs, PWTTs) �궨MKģ�͵Ĳ���
% P = p1 * T + p2
parameters = polyfit(PWTTs, BPs, 1);

end