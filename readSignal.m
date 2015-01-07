function [data,acc] = readSignal(filename)
% [data,acc] = readSignal(filename) 对数据进行解包，如果遇到丢包的情况，则对于所丢的包的数据都置为0

% /*---------------------------------------------------------------
%  * Packet structure|
%  ****************************************************************
%  *	 |	title	        |	length 	     |	value
%  *------------------------------------------------------------
%    0	 |	Start Words 	| 	2 	Words 	 |	0xffff
%  *------------------------|----------------------------
%  * 2	 |	Packet Length 	| 	1 	Word 	 |	196
%  * 3	 |	BP1 Offset  	| 	1 	word 	 |	14
%  * 4	 |	BP2 Offset  	| 	1 	word 	 |	64
%  * 5	 |	ACC1_X Offset  	| 	1 	word 	 |	114
%  * 6	 |	ACC1_Y Offset  	| 	1 	word 	 |	119
%  * 7	 |	ACC1_Z Offset  	| 	1 	word 	 |	124
%  * 8	 |	ACC2_X Offset  	| 	1 	word 	 |	129
%  * 9	 |	ACC2_Y Offset  	| 	1 	word 	 |	134
%  * 10	 |	ACC2_Z Offset  	| 	1 	word 	 |	139
%  * 11	 |	ECG Offset  	| 	1 	word 	 |	144
%  *----------------------------------------------------------
%  * 12	 |	packets count 	| 	1 	words 	 |	
%  * 13	 |	Energy Remain 	| 	1 	words 	 |	
%  * 14	 |	BP1 Signal      | 	50 	Words 	 |	
%  * 64	 |	BP2 Signal      | 	50 	words 	 |	
%  * 114 |	ACC1_X Signal  	| 	5 	word 	 |
%  * 119 |	ACC1_Y Signal  	| 	5 	word 	 |
%  * 124 |	ACC1_Z Signal  	| 	5 	word 	 |
%  * 129 |	ACC2_X Signal  	| 	5 	word 	 |
%  * 134 |	ACC2_Y Signal  	| 	5 	word 	 |
%  * 139 |	ACC2_Z Signal  	| 	5 	word 	 |	
%  * 144 |	ECG Signal 	    | 	50 	words 	 |	
%  *------------------------------------------------------------
%  * 194 |	End words       |	2 	words 	 |	0xf0f0
%  ****************************************************************

%% 常量初始化
FF = 255;
F0 = 240;
SUM_OF_START_FLAG   =   bitshift(FF,2);
SUM_OF_END_FLAG     =   bitshift(F0,2);
MAX_VALUE           =   bitshift(1,12);
PACKAGE_LENGTH      =   196;

%% 变量初始化
ppg11 = [];
ppg12 = [];
acc_ecg_x = [];
acc_ecg_y = [];
acc_ecg_z = [];
ecg1= [];
packageCount = [];

%% 读文件
D = dir(filename);
len = D.bytes;
fid1 = fopen(filename, 'rb');
orgData = fread(fid1, 'uint8');

%% 找到完整的包并进行解包
count=0;
prevPackageCount = -1;
index=find(orgData == FF|orgData == F0 );

for i = 1:length(index)-7
    if index(i+7)==index(i)+7 && sum(orgData(index(i:i+3)))==SUM_OF_END_FLAG &&sum(orgData(index(i+4:i+7)))==SUM_OF_START_FLAG && index(i+4)+PACKAGE_LENGTH*2-1<len
        fseek(fid1,index(i+4)-1+12*2,'bof');
        %% 检查丢包情况，若有丢包则将丢包的数据置为0
        currpackageCount = fread(fid1, 1, 'int16');
        packageCount(count + 1) = currpackageCount;
        if (prevPackageCount ~= -1) && (currpackageCount ~= prevPackageCount + 1)...
                && (currpackageCount ~= 0 || prevPackageCount ~= 255)
           % 找到了丢包，计算丢包数量(注意：如果丢包超过255个（大约12秒），则无法正确计算)
            if currpackageCount > prevPackageCount
                cntLost = currpackageCount - prevPackageCount;
            else
                cntLost = currpackageCount + 255 - prevPackageCount;
            end  
           % 将丢包的数据置为0
%            for k = 1 : cntLost
%                 ppg11(count*50 + [1:50]) = mean(ppg11(end - 49 : end));
%                 ppg12(count*50 + [1:50]) = mean(ppg12(end - 49 : end));
%                 acc_ecg_x(count*5 + [1:5]) = mean(acc_ecg_x(end - 4 : end));
%                 acc_ecg_y(count*5 + [1:5]) = mean(acc_ecg_y(end - 4 : end));
%                 acc_ecg_z(count*5 + [1:5]) = mean(acc_ecg_z(end - 4 : end));
%                 ecg1(count*50 + [1:50]) = mean(ecg1(end - 49 : end));      
%                 count=count+1;
%            end
        end
        fread(fid1, 1, 'int16');
        ppg11(count*50+[1:50])=MAX_VALUE-fread(fid1,50, 'int16');
        ppg12(count*50+[1:50])=MAX_VALUE-fread(fid1,50, 'int16');
        acc_ecg_x(count*5+ [1:5]) = fread(fid1,5, 'int16');
        acc_ecg_y(count*5+ [1:5]) = fread(fid1,5, 'int16');
        acc_ecg_z(count*5+ [1:5]) = fread(fid1,5, 'int16'); 
        fseek(fid1,15*2,'cof');
        ecg1(count*50+[1:50])=fread(fid1,50, 'int16');      
        count=count+1;
        i=i+8;
        prevPackageCount = currpackageCount;
    end
end
fclose('all');


data(:,1)=ppg12;
data(:,2)=ppg11;
data(:,3)=ecg1;
acc(:,1)=acc_ecg_x;
acc(:,2)=acc_ecg_z;
acc(:,3)=acc_ecg_y;
end
