function data_lowpass = low_filter(data)
        %对采集数据做加权平均

for i=6:length(data(:,1))-5
 data(i,:)=(data(i-5,:)+data(i-4,:)+data(i-3,:)+data(i-2,:)+2*data(i-1,:)+3*data(i,:)+2*data(i+1,:)+data(i+2,:)+data(i+3,:)+data(i+4,:)+data(i+5,:))/15;
end

% 对波形数据进行中值平滑
 for i=2:length(data(:,1))-1
     temp=sort(data(i-1:i+1,:));
     data(i,:)=temp(2,:);
 end
 data_lowpass=data;
end