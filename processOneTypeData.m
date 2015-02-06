function [ pwttcorr,pwfcorrelb,pwfcorrwrt ] = processOneTypeData( path,dataType )
%PROCESSONETYPEDATA �����ض��˶����͵�����
%   �������ͣ�
%       path �ַ��� ��ǰ�������ڵ�·��
%       dataType �ַ��� 'CALIBRITION' 'EXERCISE' 'STATIC' �ֱ����3����������
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

