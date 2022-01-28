function [usage_degree] = SPC_get_fifo_usage(mode)
%SPC_get_fifo_usage- The procedure sets "usage_degree" with the value in the range from 0 to 1, which tells how
%occupied is FIFO memory on the SPC module. 
    global SPC_MODULE_NUMBER
    usage_degree = 0.0;
    if mode == 0
        fprintf('\nSPC is in normal operation (routing in) mode.  Switch to FIFO mode using SPCparameters to view FIFO usage.\n');
    else
        [ret, usage_degree] = calllib('spcm64', 'SPC_get_fifo_usage', SPC_MODULE_NUMBER, usage_degree);
        if(ret<0)
            ErrorCode = ''; %enough length!
            ErrorCodePtr = libpointer('cstring', ErrorCode);
            [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 100); 
            fprintf('\nError in SPC_get_fifo_usage:\n%s. \nAborted.\n', ErrorCode);
            return;
        end
        fprintf('\nFIFO Memory Used: %f %\n', usage_degree*100);
    end
end

