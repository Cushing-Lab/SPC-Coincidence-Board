function [INIparameters] = SPC_save_parameters_to_inifile(dest_initFile, source_inifile)
%SPC_save_parameters_to_inifile- Saves parameters from SPCparameters to new
%initiation file.  MAY NOT WORK PROPERLY
    SPCparameters = SPC_get_parameters();
    
    [ret] = calllib('spcm64', 'SPC_save_parameters_to_inifile', SPCparameters, dest_inifile, source_inifile, 0);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_read_parameters_from_inifile:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
end

