function [break_time] = SPC_get_break_time()
%SPC_get_break_time- Calculates time from the start of the measurment to
%the mmoment of a measurement interruption by a user break (stop/pause
    global SPC_MODULE_NUMBER
    break_time = 0.0;
    [ret, break_time] = calllib('spcm64', 'SPC_get_break_time', SPC_MODULE_NUMBER, break_time);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_break_time:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

