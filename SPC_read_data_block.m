function [data] = SPC_read_data_block(block, page, reduction_factor, from, to, data)
%SPC__read_data_block
   
    global SPC_MODULE_NUMBER
    
    [ret, data] = calllib('spcm64', 'SPC_read_data_block', SPC_MODULE_NUMBER, block, page, reduction_factor, from, to, data);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_read_data_block:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

