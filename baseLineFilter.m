function [dataNoBase] = baseLineFilter(origin, win)
% �����˳�����Ư�ƣ�winΪ���ڳ��ȣ���������ߵ��źų��ȡ�
% �źſ�ʼ�ͽ�β�׶λ��þ��񷨲�ȫ����

len = length(origin);    
winMirror = ceil(win / 2);
winMirror = min(winMirror, len);
d = zeros(len + winMirror * 2, 1);
d(1 : winMirror) = origin(winMirror : -1 : 1);
d(winMirror + 1 : end - winMirror) = origin;
d(end - winMirror + 1 : end) = origin(end : -1 : end - winMirror + 1);
u = ones(winMirror * 2 , 1) ./ (winMirror*2);
base = conv(d, u, 'same');
dataNoBase = origin - base(winMirror + 1 : end - winMirror);

end