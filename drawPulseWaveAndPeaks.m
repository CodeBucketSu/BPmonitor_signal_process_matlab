function drawPulseWaveAndPeaks(bp, bp_peak, bp_valley, bp_key, bp_rise)
hold on
plot(bp, 'k')
plotPeak = plot(bp_peak(:, 1), bp_peak(:, 2), 'or');
plotValley = plot(bp_valley(:, 1), bp_valley(:, 2), 'og');
plotKey = plot(bp_key(:, 1), bp_key(:, 2), 'oy');
plotRise = plot(bp_rise(:, 1), bp_rise(:, 2), 'ob');
legend([plotPeak, plotValley, plotKey, plotRise], 'Peak', 'Valley', '10% Point', 'Rise');
title('key points in the pulse wave signal');

end