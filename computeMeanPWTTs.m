function meanPWTTs = computeMeanPWTTs(pwtts)


len = length(pwtts);
meanPWTTs = zeros(len, 1);

for i = 1 : len
   pwtt = pwtts{i};
   meanPWTTs(i) = mean(pwtt(:, 2)); 
    
    
end     %end for 


end