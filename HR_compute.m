%///////////////////////////////////
%检测心电图峰值
%计算心率
% input data
% output HR 
%///////////////////////////////////////////

function  [HR_peak,HR] = HR_compute(point,data,Hz)

peak_num=length(point);

%%
%心率计算
j=1;
T = floor(getSampleRate(1) / 1000 * 1200);        %60*Hz/T=50  设定阈值防止出现由于漏点造成的过低心率，阈值由平时心率来决定
for i=1:peak_num
    [vlaue,peak(i)]=max(data(point(i)-floor(getSampleRate(1) / 1000 * 400)...
      :point(i)+floor(getSampleRate(1) / 1000 * 30)));
    peak(i) = peak(i) + point(i)-floor(getSampleRate(1) / 1000 * 400);
    if i>1
       t=peak(i)-peak(i-1);
       if t > floor(getSampleRate(1) / 1000 * 300) && t < ceil(getSampleRate(1) / 1000 * 1500)               %60*Hz/0.3*T =3.3*HR,60*Hz/1.5*T=0.66*HR滤除大于平时心率和小于平时心率的0.8的点
          HR(j,1)=peak(i-1);
          HR(j,2)=60*Hz/t;
          HR_peak(j,1)=peak(i-1);
          HR_peak(j,2)=data(peak(i-1));
          j=j+1;
          %T = 0.5*T +0.5*t;
      end
    end
end
end

