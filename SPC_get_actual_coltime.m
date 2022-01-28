function [actual_coltime] = SPC_get_actual_coltime()
%SPC_get_break_time- Calculates time from the start of the measurment to
%the mmoment of a measurement interruption by a user break (stop/pause
    global SPC_MODULE_NUMBER
    actual_coltime = 0.0;
    [ret, actual_coltime] = calllib('spcm64', 'SPC_get_actual_coltime', SPC_MODULE_NUMBER, actual_coltime);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_actual_coltime:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    %In comparison to the procedure SPC_get_time_from_start, which delivers the real time from start, the procedure returns the actual state of the dead time compensated collection time. At
    %high count rates the real time of collection can be considerably longer than the specified
    %collection time value.
    %For SPC6x0,130 modules only:
    %- If the sequencer is running, the collection timer cannot be accessed.
    %- The dead time compensation can be switched off. In this case the collection timer runs with
    %the same speed as the repeat timer, and the result is the same as that of the procedure
    %SPC_get_time_from_start.
    %}
end

