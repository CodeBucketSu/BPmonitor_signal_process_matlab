function saveFigures(figures, filePath, fileNames)
% saveFigures(figures, filePath, fileNames) 保存多幅图片到指定路径
for i = 1 : length(figures)
    saveFigure(figures(i), filePath, fileNames{i});
end
end