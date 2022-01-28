function SPC_get_sequencer_state()
%SPC_get_sequencer_state- Gets the current state of the sequencer status
%bits ont he SPC module.
    global SPC_MODULE_NUMBER
    SPC_sequencer_state = 0;
    [ret,  SPC_sequencer_state] = calllib('spcm64', 'SPC_get_sequencer_state', SPC_MODULE_NUMBER,  SPC_sequencer_state);
    keys = [0, 1, 2, 4];
    vals = {'SPC SEQ 0 UNDEFINED', 'SPC_SEQ_ENABLE 0x1 sequencer is enabled', 'SPC_SEQ_RUNNING 0x2 sequencer is running only for SPC6x0/13x/15x/160 modules', 'SPC_SEQ_GAP_BANK 0x4 sequencer is waiting for other bank to be armed'};
    sequencer_status = containers.Map(keys, vals);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_sequencer_state:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    fprintf('Sequencer State:\n');
    fprintf(sequencer_status(SPC_sequencer_state));
    fprintf('\n\n');
end

