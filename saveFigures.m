function saveFigures(figures, filePath, fileNames)
% saveFigures(figures, filePath, fileNames) ������ͼƬ��ָ��·��
for i = 1 : length(figures)
    saveFigure(figures(i), filePath, fileNames{i});
end
end