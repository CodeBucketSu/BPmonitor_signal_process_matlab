function [PWTT,PWTT1,PWTT2,PWTT3,PWTT4,HR] = compute_pressure(RA, RAStart, RAEnd,mode)
% 连续血压验证实验
% 输入：桡动脉两段脉搏波
% 输出：校准后的压力脉搏波数据
% index来代指第一列，存放坐标

%% 进行滤波
RA = low_filter(RA);
RAStart = low_filter(RAStart);
RAEnd = low_filter(RAEnd);

%% 计算心率
[HR_point,HR]=HR_detection(RA);

%% 提取脉搏波关键点 计算脉搏波传输时间
[RAEnd_peak,RAEnd_valley,RAEnd_point]= Peak_detection(RAEnd);
[RAStart_peak,RAStart_valley,RAStart_point]= Peak_detection(RAStart);
%%%
figure,plot(RAEnd);
hold on ,plot(RAEnd_peak(:,1),RAEnd_peak(:,2),'o');
hold on,plot(RA,'r');
hold on ,plot(HR_point(:,1),HR_point(:,2),'o');
title('HRToRAEndpeak');
%saveas(gcf,'HRToRAEndpeak','fig');

%%%
figure,plot(RAStart);
hold on ,plot(RAStart_peak(:,1),RAStart_peak(:,2),'o');
hold on,plot(RA,'r');
hold on ,plot(HR_point(:,1),HR_point(:,2),'o');
title('HRToRAStartpeak');
%saveas(gcf,'HRToRAStartpeak','fig');
%%%
figure,plot(RAEnd);
hold on ,plot(RAEnd_peak(:,1),RAEnd_peak(:,2),'o');
hold on,plot(RAStart,'r');
hold on ,plot(RAStart_peak(:,1),RAStart_peak(:,2),'o');
title('RAStartpreakToRAEndpeak');
%saveas(gcf,'peaktopeak','fig');
%%%
figure,plot(RAEnd);
hold on ,plot(RAEnd_point(:,1),RAEnd_point(:,2),'o');
hold on,plot(RAStart,'r');
hold on ,plot(RAStart_point(:,1),RAStart_point(:,2),'o');
title('RAStartpointToRAEndpoint');
%saveas(gcf,'pointtopoint','fig');



%% 脉搏波波速     
 PWTT1 = PWTT_compute(RAEnd_peak,HR_point,200,300); %心脏 to 桡动脉末端
 PWTT2 = PWTT_compute(RAStart_peak,HR_point,200,285); %心脏 to 桡动脉始端
 PWTT3 = PWTT_compute(RAEnd_peak,RAStart_peak,15,50); %桡动脉始端 to 桡动脉末端 /峰值
 PWTT4 = PWTT_compute(RAEnd_point,RAStart_point,15,50); %桡动脉始端 to 桡动脉末端 /百分比
switch mode
    case 1
        PWTT = PWTT1;
    case 2
        PWTT = PWTT2;
    case 3
        PWTT = PWTT3;
    case 4
        PWTT = PWTT4;
end

end

