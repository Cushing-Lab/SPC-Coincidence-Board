function [time_from_start] = SPC_get_time_from_start()
%SPC_get_time_from_start- Reads the SPC repeat timer and calculates the
%time from the start of the measurement.  
    global SPC_MODULE_NUMBER
    time_from_start = 0.0;
    [ret, time_from_start] = calllib('spcm64', 'SPC_get_time_from_start', SPC_MODULE_NUMBER, time_from_start);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_time_from_start:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    time_from_start = round(time_from_start, 2);
end

