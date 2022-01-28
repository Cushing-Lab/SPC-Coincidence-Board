function [SPCModInfo] = SPC_get_module_info()
%SPC_get_module_info- Data Stored in SPCModInfo
    global SPC_MODULE_NUMBER
    SPC_MOD_INFO_STRUCT = struct('module_type', 0, 'bus_number', 0, 'slot_number', 0, 'in_use', 0, 'init', 0, 'base_adr', 0);
    SPCModInfoStruct = libstruct('s_SPCModInfo', SPC_MOD_INFO_STRUCT);
    [ret, SPCModInfo] = calllib('spcm64', 'SPC_get_module_info', SPC_MODULE_NUMBER, SPCModInfoStruct);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_module_info:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end


