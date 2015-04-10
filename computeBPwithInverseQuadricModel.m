function [BPs] = computeBPwithInverseQuadricModel(PWTTs, parameters)
% function [BPs] = computeBPwithInverseQuadricModel(PWTTs, parameters)
% BP = p1 / PWTT^2 + p2  
    
    inversePWTTs = 1/PWTTs^2;
    BPs = polyval(parameters, inversePWTTs);
    
end