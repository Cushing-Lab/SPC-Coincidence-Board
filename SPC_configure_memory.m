function [mem_info] = SPC_configure_memory(SPC_parameters)
%SPC_configure_memory- 
%ADC resolution determines length of curves- 64-4096 

%ADC_RESOLUTION – defines block_length,
%SCAN_SIZE_X, SCAN_SIZE_Y – defines blocks_per_frame
%SCAN_ROUT_X, SCAN_ROUT_Y – defines frames_per_page

    global SPC_MODULE_NUMBER
    MEM_INFO_STRUCT = struct('max_block_no', 0, 'blocks_per_frame', 0, 'frames_per_page', 0, 'maxpage', 0, 'block_length', 0);
    mem_info_struct = libstruct('s_SPCMemConfig', MEM_INFO_STRUCT);
    
    no_of_routing_bits = 0; %only one board attached
    [ret, mem_info] = calllib('spcm64', 'SPC_configure_memory', SPC_MODULE_NUMBER, SPC_parameters.adc_resolution, no_of_routing_bits, mem_info_struct);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_configure_memory:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    fprintf('\nSPC memory configured.\n');
end

