function SPC_set_page(page_no)
%SPC_fill_memory-The procedure is used to clear the measurement memory before a new measurement is started.

    global SPC_MODULE_NUMBER
 
    [ret] = calllib('spcm64', 'SPC_set_page', SPC_MODULE_NUMBER, page_no);
    if (ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_set_page:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

