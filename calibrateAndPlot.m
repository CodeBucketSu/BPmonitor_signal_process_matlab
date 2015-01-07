function [parameters] = calibrateAndPlot(BPs, PWTTs, formula)
% [parameters] = calibrate(BPs, PWTTs, formula) 根据选择的公式进行标定，并绘制标定图形
% formula：公式参数
%       'MK-MODEL'  P = p1 * log(T) + p2   
%       'POWER'     log(BP) = p1 * PWTT + p2 
%       'LINEAR'    P = p1 * T + p2
%       'QUADRIC'   P = p1 * T^2 + p2 * T + p3
switch formula
    case 'MK-MODEL'
        parameters = calibrateMKmodel(BPs, PWTTs);
        estBPs = computeBPwithMKmodel(PWTTs, parameters);
    case 'POWER'
        parameters = calibratePowerModel(BPs, PWTTs);
        estBPs = computeBPwithPowerModel(PWTTs, parameters);
    case 'LINEAR'
        parameters = calibrateLinearModel(BPs, PWTTs);
        estBPs = computeBPwithLinearModel(PWTTs, parameters);
    case 'QUADRIC'
        parameters = calibrateQuadModel(BPs, PWTTs);
        estBPs = computeBPwithQuadModel(PWTTs, parameters);
    otherwise
        parameters = calibrateMKmodel(BPs, PWTTs);
        estBPs = computeBPwithMKmodel(PWTTs, parameters);
end


hold on
plotMsr = plot(BPs, '*');     plot(BPs);
plotEst = plot(estBPs, 'r*'); plot(estBPs, 'r');
legend([plotMsr, plotEst], '测量值', '估计值');

end