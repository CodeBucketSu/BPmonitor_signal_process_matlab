function [BPs] = computeBPwithQuadModel(PWTTs, parameters)
% function [BPs] = computeBPwithQuadModel(meanPWTTS, parameters)
% P = p1 * T^2 + p2 * T + p3
   
    BPs = polyval(parameters, PWTTs);
    
end