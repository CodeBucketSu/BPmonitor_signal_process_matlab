function [estBP, CORR, MSE, ME, SVE] = calibrateAndComputeBP(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, formula)
% [corr, MSE, estBP] = calibrateAndComputeBP(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, formula)
% 根据选定的公式，利用标定数据集确定参数，并在用于验证的数据集上计算误差
% BP4Calib, PWTT4Calib：标定数据集
% BP4Esti, PWTT4Esti：测试数据集
% formula：公式参数
%       'MK-MODEL'  P = p1 * log(T) + p2   
%       'POWER'     log(BP) = p1 * PWTT + p2 
%       'LINEAR'    P = p1 * T + p2
%       'QUADRIC'   P = p1 * T^2 + p2 * T + p3

switch formula
    case 'MK-MODEL'
        paras = calibrateMKmodel(BP4Calib, PWTT4Calib);
        estBP = computeBPwithMKmodel(PWTT4Esti, paras);
    case 'POWER'
        paras = calibratePowerModel(BP4Calib, PWTT4Calib);
        estBP = computeBPwithPowerModel(PWTT4Esti, paras);
    case 'LINEAR'
        paras = calibrateLinearModel(BP4Calib, PWTT4Calib);
        estBP = computeBPwithLinearModel(PWTT4Esti, paras);
    case 'QUADRIC'
        paras = calibrateQuadModel(BP4Calib, PWTT4Calib);
        estBP = computeBPwithQuadModel(PWTT4Esti, paras);
    otherwise
        paras = calibrateMKmodel(BP4Calib, PWTT4Calib);
        estBP = computeBPwithMKmodel(PWTT4Esti, paras);
end

CORR = corr(estBP.', BP4Esti.');
MSE = computeMSE(BP4Esti, estBP);
ME = computeMeanError(BP4Esti, estBP);
SVE = computeStandardVarianceError(BP4Esti, estBP);

end