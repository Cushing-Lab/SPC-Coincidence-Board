function [SPCparameter_NEW] = SPC_get_parameter(para_name)
%SPC_set_parameters- Sets SPCparameter
    global SPC_MODULE_NUMBER
    para_id = para_name_to_id(para_name);
    val = 0.0;
    [ret, SPCparameter_NEW] = calllib('spcm64', 'SPC_get_parameter', SPC_MODULE_NUMBER, para_id, val);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 70); 
        fprintf('\nError in SPC_gtet_parameter:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end



