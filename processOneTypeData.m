function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = processOneTypeData( path,dataType )
%PROCESSONETYPEDATA 处理特定运动类型的数据
%   输入类型：
%       path 字符串 当前数据所在的路径
%       dataType 字符串 'CALIBRITION' 'EXERCISE' 'STATIC' 分别代表3种数据类型
pwttcorr = [];
pwfcorrelb = [];
pwfcorrwrt = [];
[ pwttcorr_p_c,pwfcorrelb_p_c,pwfcorrwrt_p_c ] = mainFunc('PEAK',dataType,path);
if ~isempty(pwttcorr_p_c)
    [ pwttcorr_d_c,pwfcorrelb_d_c,pwfcorrwrt_d_c ] = mainFunc('DISTANCE',dataType,path);                            
    [ pwttcorr_w_c,pwfcorrelb_w_c,pwfcorrwrt_w_c ] = mainFunc('WAVELET',dataType,path);
    
    if isequal(pwttcorr_p_c , pwttcorr_d_c) && isequal(pwttcorr_p_c, pwttcorr_w_c)
        pwttcorr = pwttcorr_p_c;
        pwfcorrelb = chooseMethod({pwfcorrelb_p_c,pwfcorrelb_d_c,pwfcorrelb_w_c});
        pwfcorrwrt = chooseMethod({pwfcorrwrt_p_c,pwfcorrwrt_d_c,pwfcorrwrt_w_c});
    end
end
end

