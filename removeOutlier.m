function [ ret, idx ] = removeOutlier( data, colNum, win)
%REMOVEOUTLIER ȥ����������������ݵ�
%  INPUT
%	data	ԭʼ����
%	colNum	��������
%	win		û���õ�
%  OUTPUT
%	ret 	���������ڵ�����
%	idx		����������������ԭʼ�����е�λ�� 

%% ���׼��
origin = data(:, colNum);
var = std(origin);

noBase = baseLineFilter(origin, 10);
idx = abs(noBase) < (var * 3);

ret = data(idx, :);

end

