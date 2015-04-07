function plotFakeEcg()
a = myEcg();
a = [a, a];
a = conv(a, ones(20, 1) * 0.05);
a = a + randn(size(a))/50;
a = conv(a, ones(20, 1) * 0.05);
a = a + randn(size(a))/100;
a = conv(a, ones(20, 1) * 0.05);
figure, plot(a) 
end


function data = myEcg()
data = ecg(1000);
data(63:217) = data(63:217)/5;
data(404:453) = data(404:453) / 2;
data(292:337) = data(292:337) / 3;
t1 = 0.005215 + (0.3 - 0.005215) / 172 * [1:172];
t2 = 0.3 + (0.0153 - 0.3) / 103 * [1:103]; 
data(501:775) = [t1, t2]; 
end