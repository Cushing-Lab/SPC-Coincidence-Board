function SPC_enable_sequencer(enable)
%SPC__enable_sequencer- 
%When ‘enable’ =1, SPC_start_measurement arms SPC for both memory banks, while for ‘enable’ =
%2, the function arms SPC only for current memory bank.
%The 2nd case is used by the main software to program Continuous Flow measurements with
%accumulation.

    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_enable_sequencer', SPC_MODULE_NUMBER,  enable);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_enable_sequencer:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    SPC_get_sequencer_state();
end

