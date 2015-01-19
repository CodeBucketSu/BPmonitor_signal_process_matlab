function saveFigure(figure, filePath, fileName)
saveas(figure, [filePath, '\', fileName], 'fig');
set(figure, 'PaperPositionMode', 'auto');
saveas(figure, [filePath, '\', fileName], 'jpg');
end