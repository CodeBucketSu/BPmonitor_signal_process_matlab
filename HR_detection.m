%///////////////////////////////////
%����ĵ�ͼ��ֵ
%��������
% input data
% output HR 
%///////////////////////////////////////////

function  [HR_peak,HR] = HR_detection(data)
%������
sample_rate=getSampleRate(1);
%��ֵ����
peak_num=0;
%��һ��Ϊ��ֵ����,�ڶ���Ϊ��ֵֵ,������Ϊ����
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
threshold = floor(sample_rate * 3 / 10);
for i = 1 : length(idxWing20p)
    peakCandi =idxWing20p(i);
    if (peakCandi > threshold) && (peakCandi < length(wing20p) - threshold)...
            && wing20p(peakCandi) == max(wing20p(peakCandi - threshold : peakCandi + threshold))
        peakCandidates(end + 1) = peakCandi;
    end
end

threshold = floor(sample_rate * 2 / 10);
delay = floor(sample_rate * 6 / 1000);
for j = 1 : length(peakCandidates)
    for i = peakCandidates(j) - 5 : peakCandidates(j) + 5;
        if data(i)==max(data(i-threshold:i+delay))   %��֤б�ʺ;ֲ����ֵ
              count=0;
            while data(i)-data(i+1)==0                    %�������������ͬ��ȡ�м�ֵ
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

%% �ų���ǰһ��������С�ĵ�
minInterval = floor(sample_rate * 4 / 10);
idx = (peak(2:end, 1) - peak(1:end - 1, 1)) > minInterval;
peak = peak(idx, :);
peak_num = size(peak, 1);

%%
%���ʼ���
j=1;
threshold = floor(sample_rate * 3 / 10);
T = floor(50 * sample_rate / 60);        %��Ӧ����Ϊ50,�趨��ֵ��ֹ��������©����ɵĹ������ʣ���ֵ��ƽʱ����������
for i=1:peak_num-1
     t=peak(i+1,peak_index)-peak(i,peak_index);
     if t > threshold && t < 1.5 *T                %�˳��ٽ���Ͳ���С��ƽʱ���ʵ�0.8
         HR(j,1)=peak(i,peak_index);
         HR(j,2)=60*sample_rate/t;
         HR_peak(j,1)=peak(i,1);
         HR_peak(j,2)=peak(i,2);
         j=j+1;
         T = 0.9*T +0.1*t;
     end
end
end






