function wl = waveletMethodB(data)
    % WAVELETMETHODB - ���ڽ�������С���任
    %   waveletMethodB(B)��B�������в���
    %   1.��n�ײ��
    %   2.��߶�Ϊscale��bior6.8С���任
    %   3.��С���任�ĵĹ�һ������
    %% Ԥ����
    n = 1; 
    scale = 8;
    %% 1
    wl = diff(data,n);
    wl = [zeros(n,1);wl(:)];
    %% 2
    wl = cwt(wl,scale,'bior6.8');
    %% 3
    wl = wl/max(abs(wl));
end