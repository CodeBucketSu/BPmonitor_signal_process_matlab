function elements = randomSelectPathModule(cellArray,num)
	%%randomSelectPathModule�������д�string��������ѡ��num��string�����
	%��Ȼ���ְ���random����������ϵ�˳����ȷ���ġ�
	if num>=length(cellArray)
		%ֻ��һ�����
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