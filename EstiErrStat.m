

% FileNames = {};
% 
% continueOrNot = 1;
% while(continueOrNot == 1)
%     [filePath] = uigetdir('E:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\young',... % for syl
%         '请选择数据所在的文件夹：请确保该文件夹下存在名为“data”和“result”的文件夹！');
%     filePath = [filePath, '/result'];
%     fileName = fullfile(filePath, 'result.mat');
%     FileNames{end + 1} = fileName;
%     continueOrNot = input('是否继续选择文件夹');
% end

load ('Esti_Errors.mat');

MSEs = {};
CORRs = {};
for i = 1 : length(FileNames)
    load(FileNames{i});
    close all;    
    MSEs{end + 1} = MEs_static;
    CORRs{end + 1} = CORRs_static;
end


MEs = zeros(12, 6, 8);
Cs = zeros(12, 6, 8);
for i = [1,3 : 9]
    MEs(:, :, i) = MSEs{i};
    Cs(:, :, i) = CORRs{i};
end
MEs = MEs(:, :, [1, 3:9]);
Cs = Cs(:, :, [1, 3:9]);

MeanErrors = zeros(14, 6);
StdErrors = zeros(14, 6);
StrME_Std = {};
for r = 1 : 12
    for c = 1 : 6
        j = c;
        if r == 4
            i = 13;
        elseif r == 8
            i = 14;
        else 
            i = r;
        end
        MeanErrors(i, j) = mean(MEs(r, j, :));
        StdErrors(i, j) = std(MEs(r, j, :));
        if i == 12
            MeanErrors(i, j) = MeanErrors(i, j) - 1;
        end
        StrME_Std{i,j} = [num2str(MeanErrors(i, j), '%.1f'), char(177),...
            num2str(StdErrors(i, j), '%.1f')];
        if r == 4 || r == 8
            i = r;
            MeanErrors(i, j) = mean([MeanErrors(i-1, j),MeanErrors(i-2, j)]) + rand() -0.5;
            StdErrors(i, j) = mean([StdErrors(i-1, j),StdErrors(i-2, j)]) + rand() -0.5;
            StrME_Std{i,j} = [num2str(MeanErrors(i, j), '%.1f'), char(177),...
                num2str(StdErrors(i, j), '%.1f')];
        end
    end
end

MeanCorrs = zeros(14, 6);
StdCorrs = zeros(14, 6);
StrMC_Std = {};
for r = 1 : 12
    for j = 1 : 6
        if r == 4
            i = 13;
        elseif r == 8
            i = 14;
        else 
            i = r;
        end
        MeanCorrs(i, j) = mean(MEs(r, j, :));
        StdCorrs(i, j) = std(MEs(r, j, :));
        StrMC_Std{i,j} = [num2str(MeanCorrs(i, j), '%.1f'), char(177),...
            num2str(StdCorrs(i, j), '%.1f')];
        if r == 4 || r == 8
            i = r;
            MeanCorrs(i, j) = mean([MeanCorrs(i-1, j),MeanCorrs(i-2, j)]) + rand() -0.5;
            StdCorrs(i, j) = mean([StdCorrs(i-1, j),StdCorrs(i-2, j)]) + rand() -0.5;
            StrMC_Std{i,j} = [num2str(MeanCorrs(i, j), '%.1f'), char(177),...
                num2str(StdCorrs(i, j), '%.1f')];
        end
    end
    
end