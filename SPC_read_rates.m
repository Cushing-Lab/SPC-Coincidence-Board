function [rate_values, repeat] = SPC_read_rates(repeat)
%SPC_read_rates- Reads the rate counters for the SPC moodule and calculates
%the rate values and writes the results to the rates structure.
    global SPC_MODULE_NUMBER
 
    RATE_VALUES_STRUCT = struct('sync_rate', 0, 'cfd_rate', 0, 'tac_rate', 0, 'adc_rate', 0);
    rate_values = libstruct('s_rate_values', RATE_VALUES_STRUCT);
    
    SPC_clear_rates(1); %otherwise returns 0 for all rates
    pause(1);
    
    [ret, rate_values] = calllib('spcm64', 'SPC_read_rates', SPC_MODULE_NUMBER, rate_values);
    if ret == '-SPC_RATES_NOT_RDY'
        fprintf('\nSPC RATES NOT READY.\n');
    elseif (ret<0) %#ok<*ST2NM>
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_read_rates:\n%s. \nAborted.\n', ErrorCode);
        return;
    elseif ret == 0
        if repeat == 1 
            x = 10 + length('\nSPC rates updated:\nSync rate: \nCFD_rate: \n') + length(rate_values.sync_rate) + length(rate_values.cfd_rate);
            for i=1:x
                fprintf('\b')
            end
        else
            repeat = 1;
        end
        
        fprintf('\nSPC rates updated:\n\nSync rate: %d\n\nCFD_rate: %d\n', rate_values.sync_rate, rate_values.cfd_rate);
    end
end

