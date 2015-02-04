function [BPs] = computeBPwithPowerModel(PWTTs, parameters)
% function [BPs] = computeBPwithPowerModel(meanPWTTS, parameters)
% BP = p1 * exp(p2 * PWTT)
%           --->
% log(BP) = log(p1) + p2 * PWTT 
%           --->
% log(BP) = p1 * PWTT + p2 
    
    
    lgBPs = polyval(parameters, PWTTs);
    BPs = exp(lgBPs);
    
end