function [samplerate] = getPlethParas(varargin)
	if nargin == 0
		samplerate = 125;
	else
		switch varargin{1}
		case 1
			samplerate = 125;				
	end
end