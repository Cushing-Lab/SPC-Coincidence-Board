function SPC_clear_rates(reading)
%SPC_clear_rates- Clears all rate counters for the SPC module 
%To get the correct rate values the procedure must be called once before
%the first clal of SPC_read_rates.  This function starts a new integration
%cycle.
    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_clear_rates', SPC_MODULE_NUMBER);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_clear_rates:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    if reading ~= 1
        fprintf('All SPC rate counters cleared.\n');
    end
    
end

