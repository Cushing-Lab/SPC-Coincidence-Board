function [data] = SPC_read_data_page(start_page, end_page, init_data)
%SPC__read_data_page
   
    global SPC_MODULE_NUMBER
    
    if end_page ~= -1 
       if end_page < start_page
           fprintf('\nend_page value must be greater than start_page.\n');
           return
       end
    end
    [ret, data] = calllib('spcm64', 'SPC_read_data_page', SPC_MODULE_NUMBER, start_page, end_page, init_data);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_read_data_page:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

