function drawECGAndPeak(ecg, peak)
hold on
plot(ecg, 'r')
plot(peak(:, 1), peak(:, 2), 'og');

title('peaks in the ecg signal');

end