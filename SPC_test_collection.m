function [data] = SPC_test_collection()
%BASIC COLLECTION SCRIPT
    clc;
    fprintf('\nMeasurement initialization in progress...\n');
    
    meas_page = 1;
    offset_val = 0;
    
    SPC_parameters = SPC_get_parameters();
    SPC_parameters = SPC_set_parameter('mode', 0); %set to normal operation mode, use 2 for FIFO mode
    SPC_parameters = SPC_set_parameter('collect_time', 0.5);
    
    SPC_mem_info = SPC_configure_memory(SPC_parameters); 
    
    max_block_no = SPC_mem_info.max_block_no;
    max_page = SPC_mem_info.maxpage;
    max_curve = max_block_no/max_page;
    block_length = SPC_mem_info.block_length;

    page_size = SPC_mem_info.blocks_per_frame * SPC_mem_info.frames_per_page * block_length;
    
    SPC_enable_sequencer(0); %disabling the sequencer
    SPC_fill_memory(meas_page, offset_val); % Clearing memory
    SPC_set_page(meas_page);
    SPC_clear_rates(0);
    SPC_get_sync_state();
    
    fprintf('\nMeasurement initialization complete.\n');
    pause(1);
    fprintf('\nMeasurement starting...\n');
    pause(1);
    
    ret = SPC_start_measurement();
    repeat = 0;
    len_prev = 0;
    
    time_from_start = 0;
    
    if ret == 0 % Measurement started successfully
        [armed, repeat, len_prev] = SPC_test_state(repeat, len_prev, time_from_start);
        time_from_start = SPC_get_time_from_start();
        fprintf('Elapsed Time: %f seconds.\n', time_from_start); 
        while armed == 1
            pause(1);
            [armed, repeat, len_prev] = SPC_test_state(repeat, len_prev, time_from_start);
            if armed == 1
                time_from_start = SPC_get_time_from_start();
                fprintf('Elapsed Time: %f seconds.\n', time_from_start); 
                %can code in collection pause here to get intermediate
                %results (line 339-360 of use_spcm.c)
            end
        end
        
        data = buffer(1:page_size, 1);
        %SPC_mem_info = SPC_configure_memory(SPC_parameters);
        %data = SPC_read_data_page(meas_page, meas_page, data);
        
        %data = SPC_read_block(0, 0, meas_page, 0, block_length-1, data);
        data = SPC_read_data_block(0, meas_page, 1, 0, block_length-1, data);
        plot(data);
    end
    
    time_from_start = SPC_get_time_from_start();
    fprintf('Measurement finished in %f seconds.\n', time_from_start);
end

