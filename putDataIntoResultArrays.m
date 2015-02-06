function [ resultArray ] = putDataIntoResultArrays(pwttcorr,pwfcorrelb,pwfcorrwrt, resultArrays )
%PUTDATAINTORESULTARRAYS
%把由每个人的每组测量数据计算出的12*4个PTT相关，33*4个PWe相关以及33*4个PWw相关加入到计算结果元胞内。
%  结果元胞结构：
%       第一个人数据组1   第一个人数据组2 ... 第一个人数据组n 第二个人数据组1 ... 第k个人1 ... 
%  ┌ corr(PWTT,BP)                                                                                                                   
%  │ p      (PWTT,BP)                                                                                                                    
%  │corr(PWTT,HR)                                                                                                                     
%  │p       (PWTT,HR)                                                                                                                               
%  │corr(PWe,BP)                                                      .                                                                         
%  │ p      (PWe,BP)                                                        .                                                                       
%  │corr(PWe,HR)                                                            .                                                         
%  │p       (PWe,HR)                                                                                                                                  
%  │corr(PWw,BP)                                                                                                                                  
%  │ p      (PWw,BP)                                                                                                                                 
%  │corr(PWw,HR)                                                                                                                                  
%  └ p       (PWw,HR)                                                                                                                                
% 上述元胞中，第1 - >4行中的每个元素都是1*12矩阵；第5- >12 行中的每个元素都是1*33矩阵

%%检查输入
if (~isequal(size(pwttcorr),[12,5])) ||(~isequal(size(pwfcorrelb),[33,5]))||(~isequal(size(pwfcorrwrt),[33,5]))
    return;
end

arraysize = size(resultArrays);
for i = 1:4
    resultArrays{i,arraysize(2)+1} = pwttcorr(:,i);
end
for i = 5:8
    resultArrays{i,arraysize(2)+1} = pwfcorrelb(:,i-4);
end
for i = 9:12
    resultArrays{i,arraysize(2)+1} = pwfcorrwrt(:,i-8);
end
resultArray = resultArrays;

end

