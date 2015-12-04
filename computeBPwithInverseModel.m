function [BPs] = computeBPwithInverseModel(PWTTs, parameters)
% function [BPs] = computeBPwithInverseModel(PWTTs, parameters)
% BP = p1 / PWTT + p2  
    
    inversePWTTs = 1./PWTTs;
    BPs = polyval(parameters, inversePWTTs);
    
end