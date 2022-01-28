function [SPCModInfo, SPC_parameters, SPC_EEP_Data, INIparameters, SPC_mem_info, page_size] = Initialize_Board()
    %% Startup
    clear;
    clc;

    % Variables
    setGlobal(0);
    init_file = 'spcm.ini';

    %Initialization
    fprintf('Initializing...\n\n');

    SPC_loadlibrary();
    SPC_init(init_file);
    SPC_get_mode();
    
    % Board Setup
    SPCModInfo = SPC_get_module_info();
    SPC_parameters = SPC_get_parameters();
    SPC_EEP_Data = SPC_get_eeprom_data();
    INIparameters = SPC_read_parameters_from_inifile(init_file);
    SPC_get_sync_state();
    SPC_clear_rates(0);
    SPC_mem_info = SPC_configure_memory(SPC_parameters);

    max_block_no = SPC_mem_info.max_block_no;
    max_page = SPC_mem_info.maxpage;
    max_curve = max_block_no/max_page;
    block_length = SPC_mem_info.block_length;

    page_size = SPC_mem_info.blocks_per_frame * SPC_mem_info.frames_per_page * block_length;
    
    fprintf('\nInitialization finished.\n');
end
