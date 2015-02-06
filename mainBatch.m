clc, clear, close all
dTs = {'CALIBRITION','EXERCISE','STATIC'};
result = {};
[filePath] = uigetdir('L:\young',... % for syl
    '请选择数据所在的文件夹：请确保该文件夹下有且仅有所有人的数据！');
directories = dir(filePath);
for i = 3:length(directories)
    onepersonpath = fullfile(filePath,directories(i).name);
    onepersonfiles = dir(onepersonpath);
        
    if length(onepersonfiles) > 2
        for j = 3:length(onepersonfiles)            
            if ~isempty(strfind(onepersonfiles(j).name,'processed'))
                onemeasurepath = fullfile(onepersonpath,onepersonfiles(j).name);
                onemeasurefiles = dir(onemeasurepath);
                hasdatafolder = 0;
                hasresultfolder = 0;
                                
                if length(onemeasurefiles)>2
                    for k = 3:length(onemeasurefiles)                        
                        if strcmp(onemeasurefiles(k).name,'data')
                            hasdatafolder = 1;
                        end
                        if strcmp(onemeasurefiles(k).name,'result')
                            hasresultfolder = 1;
                        end                        
                    end     
                    
                    if hasdatafolder
                        if ~hasresultfolder
                            mkdir(fullfile(onemeasurepath,'result'));
                        end
                        
                        for n=1:length(dTs)
                            [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = processOneTypeData(onemeasurepath,dTs{n});
                            
                            if(~isempty(pwttcorr))
                                result = putDataIntoResultArrays(pwttcorr,pwfcorrelb,pwfcorrwrt,result);
                            end
                        end                        
                    end
                end
            end            
        end        
    end
end