%/////////////////////////////////////////////////
%
%   �����������⺯����Peak_detection,����������������弰����������ʼ��
%   ���룺data���������˲����ݣ�
%   �����data_peak
%
%/////////////////////////////////////////////////

function [data_peak,data_valley,data_point] = Peak_detection(data)
%��ֵ����
peak_num=0;
H = 0.1; %�ؼ���λ��
for i=301:length(data)-301
   if data(i)-data(i-1)>0 &&data(i)>=max(data(i-300:i-1))   %���Ϊ����,�˳�����������ز���
               count=0;
         while data(i)-data(i+1)==0 %�������������ͬ��ȡ�м�ֵ
                i=i+1;
                count=count+1;
         end
      if data(i)-data(i+1)>0 &&  data(i)>=max(data(i+1:i+300)) && count<3 %�ұ�Ϊ�½�,�˳�����������ز���        
           %���㲨��λ��
            peak_index = i-ceil(count/2);
            peak_num = peak_num+1;
            peak(peak_num,1)=peak_index;    
            peak(peak_num,2)=data(peak_index); 
           %���㲨��λ�� 
            data_min=min(data(peak_index-300:peak_index));
            temp=find(data(peak_index-300:peak_index)==data_min);
            valley_index=temp(length(temp))+peak_index-300+1;
            valley(peak_num,1)=valley_index;
            valley(peak_num,2)=data_min;
            %����10%��
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



  