function [dataFilter] = sigfilter(data)

data1p = lowPassFilter(data);
dataFilter = baseLineFilter(data1p, 1500);
dataFilter = dataFilter(1000:end);

end