function meanFeatures = computeMeanFeatures(features)


len = length(features);
meanFeatures = zeros(len, 1);

for i = 1 : len
   feature = features{i};
   meanFeatures(i) = mean(feature(:, 2)); 
    
    
end     %end for 


end