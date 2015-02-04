function [BPs] = computeBPwithMKmodel(PWTTs, parameters)
% function computeBPwithMKmodel(meanPWTTS, parameters)
% P = p1 * log(T) + p2   
    
    
    BPs = polyval(parameters, log(PWTTs));
    
end