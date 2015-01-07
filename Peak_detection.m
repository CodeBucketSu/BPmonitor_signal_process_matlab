%/////////////////////////////////////////////////
%
%   脉搏波波峰检测函数：Peak_detection,用于求得脉搏波波峰及所在脉搏起始点
%   输入：data（脉搏波滤波数据）
%   输出：data_peak
%
%/////////////////////////////////////////////////

function [data_peak,data_valley,data_point] = Peak_detection(data)
%峰值个数
peak_num=0;
H = 0.1; %关键点位置
for i=301:length(data)-301
   if data(i)-data(i-1)>0 &&data(i)>=max(data(i-300:i-1))   %左边为上升,滤除随机波动和重博波
               count=0;
         while data(i)-data(i+1)==0 %如果连续极点相同，取中间值
                i=i+1;
                count=count+1;
         end
      if data(i)-data(i+1)>0 &&  data(i)>=max(data(i+1:i+300)) && count<3 %右边为下降,滤除随机波动和重博波        
           %计算波峰位置
            peak_index = i-ceil(count/2);
            peak_num = peak_num+1;
            peak(peak_num,1)=peak_index;    
            peak(peak_num,2)=data(peak_index); 
           %计算波谷位置 
            data_min=min(data(peak_index-300:peak_index));
            temp=find(data(peak_index-300:peak_index)==data_min);
            valley_index=temp(length(temp))+peak_index-300+1;
            valley(peak_num,1)=valley_index;
            valley(peak_num,2)=data_min;
            %计算10%处
            value=(peak(peak_num,2)-valley(peak_num,2))*H+valley(peak_num,2);
            [temp,index]=sort(abs(data(valley_index:peak_index)-value)); 
            point_index=index(1)+valley_index+1;
            point(peak_num,1)=point_index;     
            point(peak_num,2)=data(point_index);
        end
    end
end



data_peak=peak;
data_valley = valley;
data_point=point;
end



  