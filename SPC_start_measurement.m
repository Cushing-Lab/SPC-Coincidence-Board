function [ret] = SPC_start_measurement()
%SPC_start_measurement- 
%Before a measurement is started by SPC_start_measurement
%- the SPC parameters must be set (SPC_init or SPC_set_parameter(s) ),
%- the SPC memory must be configured ( SPC_configure_memory in normal modes),
%- the measured blocks in SPC memory must be filled (cleared) (SPC_fill_memory),
%- the measurement page must be set (SPC_set_page)

    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_start_measurement', SPC_MODULE_NUMBER);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_start_measurement:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

