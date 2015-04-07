function [BPs,PWFs] = mainFunc2(path, needPlot)
%   BPs：3   x   lenEvents   每次测量时间对应的血压，顺序为：平均压，收缩压，舒张压
%   PWFs：k  x    lenEvents  k个特征（如心率，pwtt，k，prt）所对应的单次测量均值序列
%% 只采用calibration的数据
candidates = {'pf','xc','sj'};

%% 选取数据所在文件夹
filePathForData = [path, '/data'];

%% 处理信号
fileNames = getFileNamesforBatch(candidates,filePathForData); 
if isempty(fileNames)
    return
end
[HRs, BPs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames, PWTTstats, PWFstats_elb, PWFstat_wrst, corrBpHr, figures]...
    = computeAll(filePathForData, fileNames, needPlot, '标定数据');

%% 返回
PWFs = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst, PWFnames);
end

function [PWFs] = selectPWFs(HRs, PWTTs, PWFs_elb, PWFs_wrst,PWFnames)
%采用肘部脉搏波特征
useElb = 1;
%采用第12个PWTT
selectedPwttNum = 12;
%采用的脉搏波特征特征名
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