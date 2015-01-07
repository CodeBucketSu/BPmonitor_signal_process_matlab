function [parameters] = calibratePowerModel(BPs, PWTTs)
% [parameters] = calibratePowerModel(BPs, PWTTs) �궨MKģ�͵Ĳ���
% BP = p1 * exp(p2 * PWTT)
%           --->
% log(BP) = log(p1) + p2 * PWTT 
%           --->
% log(BP) = p1 * PWTT + p2

lgBPs = log(BPs);
parameters = polyfit(PWTTs, lgBPs, 1);

end