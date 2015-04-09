function [BPs,PWFs] = mainFunc2(path, needPlot, selectedPWFNames)
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
PWFs = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames,selectedPWFNames);
end

function [PWFs] = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst,PWFnames,selectedPWFNames)
%�����ⲿ����������
useElb = 1;
%���õ�n��PWTT
selectedPwttNum = 5;
%���õ�����������������
PWFs(1,:) = PWTTs(selectedPwttNum,:);   currRow = 1;
% PWFs(currRow,:) = HRs;   currRow = 2;
for j=1:length(selectedPWFNames)
        for i=1:length(PWFnames)
                if strcmp(PWFnames{i},selectedPWFNames{j})
                    if useElb == 1
                        PWFs(currRow+j,:) = PWFs_elb(i,:);
                    else
                        PWFs(currRow+j,:) = PWFs_wrst(i,:);
                    end
                    break;
                end
        end
end
    
end