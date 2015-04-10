function elements = randomSelectPathModule(cellArray,num)
	%%randomSelectPathModule返回所有从string数组中挑选出num个string的组合
	%虽然名字包含random，但各个组合的顺序是确定的。
	if num>=length(cellArray)
		%只有一种组合
		elements={cellArray};
	else
		elements = {};

		pos = linspace(1,length(cellArray),length(cellArray));
		poses = nchoosek(pos,num);

		for i=1:length(poses(:,1))
			element = cell(1,num);
			for j=1:num
				element{j} = cellArray{poses(i,j)};
			end
			elements={elements{:},element};
		end
	end
	end