function [distances,maxpos,pointAndLineRelation] = poinToLineDistance(points,pointOnLine1,pointOnLine2)
	%% Caculate the distance between each point in [points] and a line,
	%	which conclude points {pointOnLine1}{pointOnLine2}.
	%%	INPUT
	%	points:[N,2]vector which each column conclude a series of points outside the line
	%	pointOnLine1/2:[1,2]cloumn vectors which represent two different points on the line
	%%	OUTPUT
	%	distances:[N,1]row vector Distance array between points outside the line and the line.
	%	maxpos: [1,1]the max value's pos in the distance vector
    %   pointAndLineRelation:
    %   [1,1]如果points中只包含一个点，那么该变量返回该点与直线的位置关系。1-点处于直线上方 0-点位于直线上
    %   -1-点处于直线下方
	
	%% STEP 1:Make sure the line's exist
	pointOnLine1 = (pointOnLine1(:))';
	pointOnLine2 = (pointOnLine2(:))';
	if norm(pointOnLine2- pointOnLine1) == 0
		distances=[];
		return;
	end

	%% STEP 2:Preprocess
	if size(points) == [2,1]
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
	[~, maxpos] = max(distances);

    %% STEP 5:如果只有一个点，则确定其与直线的关系
    if len ==1
        if d(1,2)>0
            pointAndLineRelation = 1;
        elseif d(1,2)==0
            pointAndLineRelation = 0;
        else
            pointAndLineRelation = 1;
        end
    end
