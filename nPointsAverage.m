function [avg] = nPointsAverage(x,n)
%%如果n为偶数,将其置为n+1
if bitget(n,1)==0
    n=n+1;
end
avg = x;
%%如果输入x不满足求平均的条件,则直接将x作为输出返回
if length(x)<=1 || n>=length(x) ||n<=1
    return;
%%前(n-1)/2与后(n-1)/2个点不求平均, 中间点均求n点平均
else
    for i=(n+1)/2:length(x)-(n-1)/2
        avg(i)=(sum(x(i-(n-1)/2:i+(n-1)/2)))/n;
    end
end
        