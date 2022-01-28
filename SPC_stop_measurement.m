function SPC_stop_measurement()
%SPC_stop_measurement- 
%If the sequencer is not enabled (normal measurement):
%- The SPC is disarmed (i.e. the photon collection is stopped)
%- The repeat and collection timers are read to get the break times
%When the sequencer is enabled:
%- The sequencer is stopped
%- The SPC is disarmed (photon collection is stopped)
%The procedure should be called after finished scan mode measurement to stop the sequencer
%and clear scan flags (SPC_FBRDY).

%For all SPC module types (except SPC-6x0/130/131) in SCAN_IN mode:
%If the measurement was started in SCAN_IN mode, 1st call to the function forces very short
%collection time to finish the current frame and returns error -21. The measurement will stop
%automatically after finishing current frame. 2nd call will stop the measurement without waiting
%for the end of frame.

    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_stop_measurement', SPC_MODULE_NUMBER);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_stop_measurement:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

