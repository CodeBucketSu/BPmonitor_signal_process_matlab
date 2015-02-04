clc, clear
fileName = 'D:\02_MyProjects\BloodPressure\04_softwares\interface_python\BPMonitor_git\data\syl\2014_10_29_20_34\2014_10_29_20_51_ql.uEvent';
events = readEvent(fileName);
len = length(events);
for i = 1:len
    event = events{1};
    keys(event)
    values(event)
end
        