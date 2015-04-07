function [BPs,PWFs] = mainFunc2(path, needPlot)
%   BPs��3   x   lenEvents   ÿ�β���ʱ���Ӧ��Ѫѹ��˳��Ϊ��ƽ��ѹ������ѹ������ѹ
%   PWFs��k  x    lenEvents  k�������������ʣ�pwtt��k��prt������Ӧ�ĵ��β�����ֵ����
%% ֻ����calibration������
candidates = {'pf','xc','sj'};

%% ѡȡ���������ļ���
filePathForData = [path, '/data'];

%% �����ź�
fileNames = getFileNamesforBatch(candidates,filePathForData); 
if isempty(fileNames)
    return
end
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForData, fileNames, needPlot, '�궨����');

%% ����
PWFs = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames);
end

function [PWFs] = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst,PWFnames)
%�����ⲿ����������
useElb = 1;
%���õ�12��PWTT
selectedPwttNum = 12;
%���õ�����������������
selectedPWFNames = {'KVAL','PRT'};
PWFs(1,:) = PWTTs(selectedPwttNum,:);
for j=1:length(selectedPWFNames)
        for i=1:length(PWFnames)
                if strcmp(PWFnames{i},selectedPWFNames{j})
                    if useElb == 1
                        PWFs(1+j,:) = PWFs_elb(i,:);
                    else
                        PWFs(1+j,:) = PWFs_wrst(i,:);
                    end
                    break;
                end
        end
end
    
end