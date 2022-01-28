function SPC_pause_measurement()
%SPC_pause_measurement- 
%When the sequencer is not enabled (normal measurement):
%- the repeat and collection timers are stopped,
%- the SPC is disarmed (photon collection is stopped).
%When the sequencer is enabled:
%-an error is returned - this measurement can’t be paused

    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_pause_measurement', SPC_MODULE_NUMBER);
    if ret == 0
        fprintf('\nSPC measurement finished- cannot be paused.\n');
    elseif ret>0
        fprintf('\nSPC measurement paused.\n');
    elseif ret<0
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_pause_measurement:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

