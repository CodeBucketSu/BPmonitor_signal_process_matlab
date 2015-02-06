%///////////////////////////////////
%����ĵ�ͼ��ֵ
%��������
% input data
% output HR 
%///////////////////////////////////////////

function  [HR_peak,HR] = HR_detection(data)
%��ֵ����
peak_num=0;
%��һ��Ϊ��ֵ����,�ڶ���Ϊ��ֵֵ,������Ϊ����
peak_index=1;
peak_value=2;
wing20 = wingFunc(data, 20);
thres = mean(wing20(wing20 > 0));
thres2 = mean(wing20(wing20 > thres));
thres = (3 * thres + thres2) / 4;
for i=201:length(data)-200
    if (data(i)-data(i-20))*(data(i)-data(i+20))>thres &&  data(i)==max(data(i-200:i+60))   %��֤б�ʺ;ֲ����ֵ
          count=0;
        while data(i)-data(i+1)==0                    %�������������ͬ��ȡ�м�ֵ
               i=i+1;
               count=count+1;
        end
      
      if count<10 % && min(data(i:i+40)) == min(data(i-200:i+100)) 
            index = ceil(i-count/2);
            peak_num = peak_num+1;
            peak(peak_num,peak_index)=index;    
            peak(peak_num,peak_value)=data(index);
      end
    end
end

%% �ų���ǰһ��������С�ĵ�
minInterval = 400;
idx = (peak(2:end, 1) - peak(1:end - 1, 1)) > minInterval;
peak = peak(idx, :);
peak_num = size(peak, 1);

%%
%���ʼ���
j=1;
T = 1200;        %��Ӧ����Ϊ50,�趨��ֵ��ֹ��������©����ɵĹ������ʣ���ֵ��ƽʱ����������
for i=1:peak_num-1
     t=peak(i+1,peak_index)-peak(i,peak_index);
     if t > 300 && t < 1.2 *T                %�˳��ٽ���Ͳ���С��ƽʱ���ʵ�0.8
         HR(j,1)=peak(i,peak_index);
         HR(j,2)=60*1000/t;
         HR_peak(j,1)=peak(i,1);
         HR_peak(j,2)=peak(i,2);
         j=j+1;
         T = 0.7*T +0.3*t;
     end
end
end






