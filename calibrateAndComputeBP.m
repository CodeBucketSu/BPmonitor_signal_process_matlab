function [estBP, CORR, MSE, ME, SVE] = calibrateAndComputeBP(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, formula)
% [corr, MSE, estBP] = calibrateAndComputeBP(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, formula)
% ����ѡ���Ĺ�ʽ�����ñ궨���ݼ�ȷ������������������֤�����ݼ��ϼ������
% BP4Calib, PWTT4Calib���궨���ݼ�
% BP4Esti, PWTT4Esti���������ݼ�
% formula����ʽ����
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