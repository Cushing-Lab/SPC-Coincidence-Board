function SPC_fill_memory(page, fill_value)
%SPC_fill_memory-The procedure is used to clear the measurement memory before a new measurement is started.

    global SPC_MODULE_NUMBER
    block = -1;
    [ret] = calllib('spcm64', 'SPC_fill_memory', SPC_MODULE_NUMBER, block, page, fill_value);
    if ret == 0
        fprintf('\nSPC memory fill complete.\n');
    elseif (ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_fill_memory:\n%s. \nAborted.\n', ErrorCode);
        return;
    else
        fprintf('\nMemory filling in progress.\n', ret);
        pause(3);
    end
end

