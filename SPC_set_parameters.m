function [SPCparameters_NEW] = SPC_set_parameters(SPCparameters)
%SPC_set_parameters- Sets SPCparameters
    global SPC_MODULE_NUMBER
    SPC_DATA_STRUCT = struct('base_adr', 0, 'init', 0, 'cfd_limit_low', 0, 'cfd_limit_high', 0, 'cfd_zc_level', 0, 'cfd_holdoff', 0, 'sync_zc_level',0, 'sync_holdoff', 0, 'sync_threshold', 0, 'tac_range', 0, 'sync_freq_div', 0, 'tac_gain', 0, 'tac_offset', 0, 'tac_limit_low', 0, 'tac_limit_high', 0, 'adc_resolution', 0, 'ext_latch_delay', 0, 'collect_time', 0, 'display_time', 0, 'repeat_time', 0, 'stop_on_time', 0, 'stop_on_ovfl', 0, 'dither_range', 0, 'count_incr', 0, 'mem_bank', 0, 'dead_time_comp', 0, 'scan_control', 0, 'routing_mode', 0, 'tac_enable_hold', 0, 'pci_card_no', 0, 'mode', 0, 'scan_size_x', 0, 'scan_size_y', 0, 'scan_rout_x', 0, 'scan_rout_y', 0,  'scan_flyback', 0, 'scan_borders', 0, 'scan_polarity', 0,  'pixel_clock', 0, 'line_compression', 0, 'trigger', 0, 'pixel_time', 0,  'ext_pixclk_div', 0, 'rate_count_time', 0, 'macro_time_clk', 0, 'add_select', 0, 'test_eep', 0, 'adc_zoom', 0, 'img_size_x', 0, 'img_size_y', 0, 'img_rout_x', 0,  'img_rout_y', 0, 'xy_gain', 0, 'master_clock', 0, 'adc_sample_delay', 0,  'detector_type', 0, 'chan_enable', 0, 'chan_slope', 0, 'chan_spec_no', 0, 'x_axis_type', 0);

    SPCparametersStruct = libstruct('s_SPCdata', SPCparameters);
    [ret, SPCparameters] = calllib('spcm64', 'SPC_set_parameters', SPC_MODULE_NUMBER, SPCparametersStruct);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 70); 
        fprintf('\nError in SPC_set_parameters:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    SPCparameters_NEW = SPC_get_parameters(SPC_MODULE_NUMBER, SPC_DATA_STRUCT);
    
end



