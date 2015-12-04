function [peaks,onsets]=detectPeakAndOnsetsInBPWave(data)
%% ´ÓÁ¬ĞøÑªÑ¹Êı¾İÖĞ¼ì²âÊæÕÅÑ¹ÓëÊÕËõÑ¹Î»ÖÃ

%% ²½Öè1£º¼ì²âÂö²«²¨·å
peaks = detetectPeaksInPulseWave(data, 60);  

%% ²½Öè2£º¼ì²âÂö²«²¨Æğµã£¬²¢Óëpeaks¶ÔÆë
onsets_tmp = detectOnsetsInPulseWave(data, peaks);
onsets = alignDataAccordingToReferenceData(onsets_tmp, peaks, floor(getSampleRate(2) /1000 * -300), -10);
error = find(onsets(:, 1) == -1);
if length(error) > 0
    input('error');
end
end