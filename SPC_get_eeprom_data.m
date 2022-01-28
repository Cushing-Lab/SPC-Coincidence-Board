function [SPC_EEP_Data] = SPC_get_eeprom_data()
%SPC_get_eeprom_data- Data stored in SPC_EEP_Data
    global SPC_MODULE_NUMBER
    SPC_ADJUST_PARA_STRUCT = struct('vrt1', 0, 'vrt2', 0, 'vrt3', 0, 'dith_g', 0, 'gain_1', 0, 'gain_2', 0, 'gain_4', 0, 'gain_8', 0, 'tac_r0', 0, 'tac_r1', 0, 'tac_r2', 0, 'tac_r4', 0, 'tac_r8', 0, 'sync_div', 0');
    SPC_EEP_DATA_STRUCT = struct('module_type', zeros(1, 8), 'serial_no', zeros(1, 6), 'date', zeros(1, 8), 'adj_para', SPC_ADJUST_PARA_STRUCT);
    
    SPC_EEP_Data_Struct = libstruct('s_SPC_EEP_Data', SPC_EEP_DATA_STRUCT);
    [ret, SPC_EEP_Data] = calllib('spcm64', 'SPC_get_eeprom_data', SPC_MODULE_NUMBER, SPC_EEP_Data_Struct);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_get_eeprom_data:\n%s. \nAborted.\n', ErrorCode);
        return;
    else 
        SPC_EEP_Data.module_type = char(SPC_EEP_Data.module_type);
        SPC_EEP_Data.serial_no = char(SPC_EEP_Data.serial_no);
        SPC_EEP_Data.date = char(SPC_EEP_Data.date);
        SPC_Adjust_Para = SPC_EEP_Data.adj_para; %Same as SPC_get_adjust_parameters
        %Manual recommends not adjusting the SPC_Adjust_Para as the module
        %function can be seriously corrupted by the wrong adjust values.
    end
end


