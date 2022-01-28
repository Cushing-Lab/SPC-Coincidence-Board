function [gap_time] = SPC_read_gap_time()
%SPC_read_gap_time- The procedure is used to read the gap time that can occur during a measurement.
%gap_time is set to the last gap time in ms on the SPC module ‘mod_no’.
    global SPC_MODULE_NUMBER
    gap_time = 0.0;
    [ret, gap_time] = calllib('spcm64', 'SPC_read_gap_time', SPC_MODULE_NUMBER, gap_time);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_read_gap_time:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    fprintf('Last gap time on SPC Module was: %f ms\n', gap_time);
end

