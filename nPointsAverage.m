function [avg] = nPointsAverage(x,n)
%%���nΪż��,������Ϊn+1
if bitget(n,1)==0
    n=n+1;
end
avg = x;
%%�������x��������ƽ��������,��ֱ�ӽ�x��Ϊ�������
if length(x)<=1 || n>=length(x) ||n<=1
    return;
%%ǰ(n-1)/2���(n-1)/2���㲻��ƽ��, �м�����n��ƽ��
else
    for i=(n+1)/2:length(x)-(n-1)/2
        avg(i)=(sum(x(i-(n-1)/2:i+(n-1)/2)))/n;
    end
end
        