function [ resultArray ] = putDataIntoResultArrays(pwttcorr,pwfcorrelb,pwfcorrwrt, resultArrays )
%PUTDATAINTORESULTARRAYS
%����ÿ���˵�ÿ��������ݼ������12*4��PTT��أ�33*4��PWe����Լ�33*4��PWw��ؼ��뵽������Ԫ���ڡ�
%  ���Ԫ���ṹ��
%       ��һ����������1   ��һ����������2 ... ��һ����������n �ڶ�����������1 ... ��k����1 ... 
%  �� corr(PWTT,BP)                                                                                                                   
%  �� p      (PWTT,BP)                                                                                                                    
%  ��corr(PWTT,HR)                                                                                                                     
%  ��p       (PWTT,HR)                                                                                                                               
%  ��corr(PWe,BP)                                                      .                                                                         
%  �� p      (PWe,BP)                                                        .                                                                       
%  ��corr(PWe,HR)                                                            .                                                         
%  ��p       (PWe,HR)                                                                                                                                  
%  ��corr(PWw,BP)                                                                                                                                  
%  �� p      (PWw,BP)                                                                                                                                 
%  ��corr(PWw,HR)                                                                                                                                  
%  �� p       (PWw,HR)                                                                                                                                
% ����Ԫ���У���1 - >4���е�ÿ��Ԫ�ض���1*12���󣻵�5- >12 ���е�ÿ��Ԫ�ض���1*33����

%%�������
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

