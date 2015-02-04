function [distances,maxpos,pointAndLinesRelation] = poinToLineDistance(points,pointOnLine1,pointOnLine2,upOrDown)
	%% Caculate the distance between each point in [points] and a line,
	%	which conclude points {pointOnLine1}{pointOnLine2}.
	%%	INPUT
	%	points:[N,2]vector which each column conclude a series of points outside the line
	%	pointOnLine1/2:[1,2]cloumn vectors which represent two different points on the line
    %   upOrDown:1 - Ѱ��ֱ���Ϸ����е����ֵ 0 - Ѱ��ֱ���·������ֵ
	%%	OUTPUT
	%	distances:[N,1]row vector Distance array between points outside the line and the line.
	%	maxpos: [1,1]the max value's pos in the distance vector
    %   pointAndLinesRelation: ���points����ֻ����һ���㣬��ô�������ֵ��ӳ���������ֱ�ߵ����λ�ù�ϵ
    %   -1 - ����ֱ���� 0 - ����ֱ���� 1 - ����ֱ���� ���� - δ֪ �����ֱ�߲�������x�ᴹֱ
	%% �жϲ����Ƿ����Ҫ��
    narginchk(3,4);
    
	%% STEP 1:Make sure the line's exist
	pointOnLine1 = (pointOnLine1(:))';
	pointOnLine2 = (pointOnLine2(:))';
	if norm(pointOnLine2- pointOnLine1) == 0
		distances=[];
		return;
	end

	%% STEP 2:Preprocess
	if size(points)==[2,1]
		points = points';
	end
	len = length(points(:,1));
	q1 = ones(len,1)*pointOnLine1;
	q2 = ones(len,1)*pointOnLine2;

	%% STEP 3:Calculate distance vector
	d = (points -q1) - (points - q1)*(pointOnLine2 - pointOnLine1)'*[1 1].*(q2 - q1)/...
		norm(pointOnLine2 - pointOnLine1)^2;

	%% STEP 4:Calculate norm distances
    distances = sqrt(d(:,1).^2 + d(:,2).^2);
	if nargin == 4
        if upOrDown==1
            [~,maxpos] = max(distances.*(d(:,2)./abs(d(:,2))));
        else
            [~,maxpos] = min(distances.*(d(:,2)./abs(d(:,2))));
        end
    else
        [~, maxpos] = max(distances);
    end
    
    %% PLOT TEST
%     close all
%     plot(points(:,1),points(:,2),'r');
%     hold on;
%     line([pointOnLine1(1,1),pointOnLine2(1,1)],[pointOnLine1(1,2),pointOnLine2(1,2)]);

    %% STEP 5:�жϵ���ֱ�ߵĹ�ϵ
    pointAndLinesRelation = -2;
    if length(d(:,1)) == 1
        if d(:,2) > 0
            pointAndLinesRelation = 1;
        elseif d(:,2) == 0
            pointAndLinesRelation = 0;
        else
            pointAndLinesRelation = -1;
        end
    end
