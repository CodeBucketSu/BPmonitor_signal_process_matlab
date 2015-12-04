function sampleRate = getSampleRate(varargin)
%% Probably the parameter list is as below:
% 1st - Kind of the signal(1=ecg;2=ppg;3=abp)
% 2nd - Directory of the samplerate.mat file
 defaultSampleRate = 125;
 try
	 tStruct = load('samplerate.mat');
	 sampleRate = tStruct.samplerate;
 catch e
	 sampleRate = defaultSampleRate;
 end
 
end
