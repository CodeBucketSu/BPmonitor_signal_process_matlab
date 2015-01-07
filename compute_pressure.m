function [PWTT,PWTT1,PWTT2,PWTT3,PWTT4,HR] = compute_pressure(RA, RAStart, RAEnd,mode)
% ����Ѫѹ��֤ʵ��
% ���룺�㶯������������
% �����У׼���ѹ������������
% index����ָ��һ�У��������

%% �����˲�
RA = low_filter(RA);
RAStart = low_filter(RAStart);
RAEnd = low_filter(RAEnd);

%% ��������
[HR_point,HR]=HR_detection(RA);

%% ��ȡ�������ؼ��� ��������������ʱ��
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



%% ����������     
 PWTT1 = PWTT_compute(RAEnd_peak,HR_point,200,300); %���� to �㶯��ĩ��
 PWTT2 = PWTT_compute(RAStart_peak,HR_point,200,285); %���� to �㶯��ʼ��
 PWTT3 = PWTT_compute(RAEnd_peak,RAStart_peak,15,50); %�㶯��ʼ�� to �㶯��ĩ�� /��ֵ
 PWTT4 = PWTT_compute(RAEnd_point,RAStart_point,15,50); %�㶯��ʼ�� to �㶯��ĩ�� /�ٷֱ�
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

