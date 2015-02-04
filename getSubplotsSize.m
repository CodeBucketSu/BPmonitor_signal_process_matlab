function [row, col] = getSubplotsSize(numOfSubplot)
row = floor(sqrt(numOfSubplot));
col = ceil(numOfSubplot / row);
end