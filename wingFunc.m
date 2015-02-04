function dataWing = wingFunc(data, win)
% wingFunc ����data��������winΪ���ȣ���:
%  dataWing(i) = (data(i) - data(i - win)) * (data(i) - data(i + win))
len = length(data);
win = min(len - 1, 2 * win) / 2;
dataWing = zeros(size(data));
dataWing(win + 1 : end - win) = (data(win + 1 : end - win) - data(1 : end - 2 * win))...
    .* (data(win + 1 : end - win) - data(1 + 2 * win : end));

end