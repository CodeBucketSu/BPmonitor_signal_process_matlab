function [events] = readEvent(fileName)
    fid = fopen(fileName, 'r');
    events = {};
    while 1
        event = containers.Map();
        line = fgetl(fid);
        if ~ischar(line)
            break;
        end
        line = line(2:end-1);
        disp(line);
        S = regexp(line, ', ', 'split');
        len = length(S);
        for i = 1 : len
            SS = regexp(S{i}, ': ', 'split');
            key = char(SS{1});
            value = char(SS{2});
            % remove the single quotaion marks
            key = key(2:end-1);
            if value(1) == ''''
                value = value(2:end-1);
            end
            % remove the L postfix for long integer
            if value(end) =='L'
                value = value(1:end-1);
            end
            % change the string into double
            if ~ isnan(str2double(value))
                value = str2double(value);
            end
            % add the mapentry
            event(key) = value;
        end
        events(end + 1) = {event};
    end
    fclose(fid);
end