function [MSEs, MEs, SVEs, CORRs, estBPs] = calibrateAndComputeBPwithDifferentModel(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, corrPwttHr, formulas)
% [estBPs, CORRs, MSEs] = calibrateAndComputeBPwithDifferentModel(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti)
% ���ݲ�ͬ�Ĺ�ʽ���ֱ�Ա궨���ݼ����б궨��������֤���ݼ�������֤
% BP4Calib, PWTT4Calib���궨���ݼ�
% BP4Esti, PWTT4Esti���������ݼ�
% �������¹�ʽ��
%       'MK-MODEL'  P = p1 * log(T) + p2   
%       'POWER'     log(BP) = p1 * PWTT + p2 
%       'LINEAR'    P = p1 * T + p2
%       'QUADRIC'   P = p1 * T^2 + p2 * T + p3

% formulas = {'MK-MODEL', 'POWER', 'LINEAR', 'QUADRIC'};
estBPs = zeros(length(formulas), length(PWTT4Esti));
CORRs = zeros(length(formulas), 1);
MSEs = zeros(length(formulas), 1);
MEs = zeros(length(formulas), 1);
SVEs = zeros(length(formulas), 1);
plots = zeros(length(formulas) + 1, 1);

hold on;
title('�������ݼ�������');
colors = {'r', 'g', 'b', 'm', 'c', 'k'};
colorsdot = {'*r', '*g', '*b', '*m', '*c', '*k'};
plots(1) = plot(BP4Esti, colors{1}); 
plot(BP4Esti, 'r*');
ttl = {};
formatSpec='%.1f';
for i = 1 : length(formulas)

    [estBPs(i, :), CORRs(i, :), MSEs(i, :), MEs(i, :), SVEs(i, :)] = calibrateAndComputeBP(BP4Calib, PWTT4Calib, BP4Esti, PWTT4Esti, formulas{i});
    
    plots(i + 1) = plot(estBPs(i, :), colors{i + 1});
    plot(estBPs(i, :), colorsdot{i + 1});
    
    % ��������
    ttl{i} = [formulas{i}, ': ME = ', num2str(MEs(i, :),formatSpec), ', VE = ', num2str(SVEs(i, :),formatSpec), ',CORR = ', num2str(CORRs(i, :),'%.3f')];
end
ttl{end + 1} = ['   meanCorrPWTT2PWTT: ', num2str(corrPwttHr)];
legend(plots, ['measured', formulas]);
title(ttl);