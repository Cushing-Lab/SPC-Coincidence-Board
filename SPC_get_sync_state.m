function [SPC_sync_state] = SPC_get_sync_state()
%SPC_get_sync_state- Outputs sync state of the module- Printed in command
%window
    global SPC_MODULE_NUMBER
    SPC_sync_state = 0;
    [ret, SPC_sync_state] = calllib('spcm64', 'SPC_get_sync_state', SPC_MODULE_NUMBER, SPC_sync_state);
    keys = [0, 1, 2, 3];
    vals = {'NO SYNC, sync input not triggered', 'SYNC OK, sync input triggers', 'SYNC OVERLOAD.', 'SYNC OVERLOAD.'};
    sync_status = containers.Map(keys, vals);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_sync_state:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    
    fprintf('Sync State: ');
    fprintf(sync_status(SPC_sync_state));
    fprintf('\n');
end

