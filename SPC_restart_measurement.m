function SPC_restart_measurement()
%SPC_restart_measurement-The procedure is used to restart a measurement that was paused by SPC_pause_measurement
%on the SPC module
%When the sequencer is not enabled (normal measurement):
%- the repeat and collection timers are started,
%- the SPC is armed (photon collection is started).
%When the sequencer is enabled:
%-an error is returned, this measurement can’t be restarted
    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_restart_measurement', SPC_MODULE_NUMBER);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_restart_measurement:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

