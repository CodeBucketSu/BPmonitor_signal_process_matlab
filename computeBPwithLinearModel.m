function [BPs] = computeBPwithLinearModel(PWTTs, parameters)
% function [BPs] = computeBPwithLinearModel(meanPWTTS, parameters)
% P = p1 * T + p2   
    
    
    BPs = polyval(parameters, PWTTs);
    
end