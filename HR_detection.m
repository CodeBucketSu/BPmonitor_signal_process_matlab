%///////////////////////////////////
%检测心电图峰值
%计算心率
% input data
% output HR 
%///////////////////////////////////////////

function  [HR_peak,HR] = HR_detection(data)
%峰值个数
peak_num=0;
%第一列为峰值坐标,第二列为峰值值,第三列为心率
peak_index=1;
peak_value=2;
wing20 = wingFunc(data, 20);
wing3 = wingFunc(data, 3);
delta5 = data(6:end) - data(1:end-5);
delta5 = [zeros(5, 1); delta5];
wing20p = wing20;
wing20p(wing3 <= 0) = 0;
wing20p(delta5 <= 0) = 0;

idxWing20p = find(wing20p>0);
peakCandidates = [];
for i = 1 : length(idxWing20p)
    peakCandi =idxWing20p(i);
    if (peakCandi > 300) && (peakCandi < length(wing20p) - 300)...
            && wing20p(peakCandi) == max(wing20p(peakCandi - 300 : peakCandi + 300))
        peakCandidates(end + 1) = peakCandi;
    end
end

for j = 1 : length(peakCandidates)
    for i = peakCandidates(j) - 5 : peakCandidates(j) + 5;
        if data(i)==max(data(i-200:i+60))   %保证斜率和局部最大值
              count=0;
            while data(i)-data(i+1)==0                    %如果连续极点相同，取中间值
                   i=i+1;
                   count=count+1;
            end

          if count<8 % && min(data(i:i+40)) == min(data(i-200:i+100)) 
                index = ceil(i-count/2);
                peak_num = peak_num+1;
                peak(peak_num,peak_index)=index;    
                peak(peak_num,peak_value)=data(index);
          end
        end
    end
end

%% 排除与前一个点距离过小的点
minInterval = 400;
idx = (peak(2:end, 1) - peak(1:end - 1, 1)) > minInterval;
peak = peak(idx, :);
peak_num = size(peak, 1);

%%
%心率计算
j=1;
T = 1200;        %对应心率为50,设定阈值防止出现由于漏点造成的过低心率，阈值由平时心率来决定
for i=1:peak_num-1
     t=peak(i+1,peak_index)-peak(i,peak_index);
     if t > 300 && t < 1.5 *T                %滤除临近点和不能小于平时心率的0.8
         HR(j,1)=peak(i,peak_index);
         HR(j,2)=60*1000/t;
         HR_peak(j,1)=peak(i,1);
         HR_peak(j,2)=peak(i,2);
         j=j+1;
         T = 0.9*T +0.1*t;
     end
end
end






