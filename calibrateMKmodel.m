function [parameters] = calibrateMKmodel(BPs, PWTTs)
% [parameters] = calibrateMKmodel(BPs, PWTTs) �궨MKģ�͵Ĳ���
% P = p1 * lnT + p2
% p1 < 0
lgPWTTs = log(PWTTs);
parameters = polyfit(lgPWTTs, BPs, 1);

end