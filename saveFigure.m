function saveFigure(figure, filePath, fileName)
saveas(figure, fullfile(filePath,fileName), 'fig');
set(figure, 'PaperPositionMode', 'auto');
saveas(figure, fullfile(filePath,fileName), 'jpg');
end