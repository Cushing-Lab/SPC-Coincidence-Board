function [armed, repeat, len_prev] = SPC_test_state(repeat, len_prev, time_from_start)
%SPC_test_state- Testing the state of the module- State printed in command
%Window
    global SPC_MODULE_NUMBER
    state = 0;
    armed = 1;
    [ret, state] = calllib('spcm64', 'SPC_test_state', SPC_MODULE_NUMBER, state);
    state = dec2hex(state);
    key = [1, 2, 4, 8, 10, 80, 20, 100, 200, 40, 400, 800, 1000, 8000];
    vals = {'SPC_OVERFL: Stopped on overflow', 'SPC_OVERFLOW Overflow occurred', 'SPC_TIME_OVER: Stopped on expiration of collection timer', 'SPC_COLTIM_OVER: Collection timer expired', 'SPC_CMD_STOP: Stopped on user command', 'SPC_ARMED: Measurement in progress (current bank)', 'SPC_REPTIM_OVER: Repeat timer expired', 'SPC_COLTIM_2OVER: Second overflow of collection timer', 'SPC_REPTIM_2OVER: Second overflow of repeat timer', 'SPC_SEQ_GAP: Sequencer is waiting for other bank to be armed', 'SPC_FOVFL: Fifo overflow, data lost', 'SPC_FEMPTY: Fifo empty', 'SPC_WAIT_TRG: Wait for external trigger', 'SPC_HFILL_NRDY: Hardware fill not finished'};
    statusBits = containers.Map(key, vals);
    if(ret<0)
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nError in SPC_test_state:\n%s. \nAborted.\n', ErrorCode);
        return;
    end
    hexVals = mat2cell(state, 1, [1, 1, 1]);
    [hundreds, tens, ones] = hexVals{:};
    
    
    if repeat == 1 
        if time_from_start < 10.0
            len_prev = len_prev + 31 + length(time_from_start);
        elseif time_from_start < 100.0
            len_prev = len_prev + 32 + length(time_from_start);
        elseif time_from_start < 1000.0
            len_prev = len_prev + 33 + length(time_from_start);
        elseif time_from_start < 10000.0
            len_prev = len_prev + 34 + length(time_from_start);
        end
            
        for i=1:len_prev
            fprintf('\b')
        end
    else
        repeat = 1;
    end
    
    len_prev = length('nModule State:n');
      
    fprintf('\nModule State:\n');
    if ones == 'C'
        fprintf(statusBits(8));
        fprintf('\n');
        fprintf(statusBits(4));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(8)) + length(statusBits(4)) + 2;
        armed = 0;
    elseif ones == 'A'
        fprintf(statusBits(8));
        fprintf('\n');
        fprintf(statusBits(2));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(8)) + length(statusBits(2)) + 2;
    elseif ones == '9'
        fprintf(statusBits(8));
        fprintf('\n');
        fprintf(statusBits(1));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(1)) + length(statusBits(8)) + 2;
        break_time = SPC_get_break_time();
        fprintf('\nSPC overflow at %d\n', break_time);
        armed = 0;
    elseif ones == '3'
        fprintf(statusBits(2));
        fprintf('\n');
        fprintf(statusBits(1));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(2)) + length(statusBits(1)) + 2;
        break_time = SPC_get_break_time();
        fprintf('\nSPC overflow at %d\n', break_time);
        armed = 0;
    elseif ones == '6'
        fprintf(statusBits(4));
        fprintf('\n');
        fprintf(statusBits(2));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(2)) + length(statusBits(4)) + 2;
        armed = 0;
    elseif ones ~= '0'
        fprintf(statusBits(str2double(ones)));
        fprintf('\n');
        if str2double(ones) == 1
            break_time = SPC_get_break_time();
            fprintf('\nSPC overflow at %d\n', break_time);
        end
        len_prev = len_prev + length(statusBits(str2double(ones))) + 1;
        armed = 0;
    end 
    
    if tens == 'A'
        fprintf(statusBits(80));
        fprintf('\n');
        fprintf(statusBits(20));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(80)) + length(statusBits(20)) + 2;
        armed = 0;
    elseif tens == '3'
        fprintf(statusBits(10));
        fprintf('\n');
        fprintf(statusBits(20));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(20)) + length(statusBits(10)) + 2;
        armed = 0;
    elseif tens == '5'
        fprintf(statusBits(10));
        fprintf('\n');
        fprintf(statusBits(40));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(10)) + length(statusBits(40)) + 2;
        armed = 0;
    elseif tens == '6'
        fprintf(statusBits(40));
        fprintf('\n');
        fprintf(statusBits(20));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(20)) + length(statusBits(40)) + 2;
        armed = 0;
    elseif tens == 'C'
        fprintf(statusBits(40));
        fprintf('\n');
        fprintf(statusBits(80));
        fprintf('\n');  
        len_prev = len_prev + length(statusBits(80)) + length(statusBits(40)) + 2;
    elseif tens ~= '0'
        if tens ~= '80'
            armed = 0;
        else
            armed = 1;
        end
        fprintf(statusBits(str2double(tens)*10));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(str2double(tens)*10)) + 1;
    else
        armed = 0;
    end
    
    if hundreds == '9'
        fprintf(statusBits(800));
        fprintf('\n');
        fprintf(statusBits(100));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(800)) + length(statusBits(100)) + 2;
    elseif hundreds == 'A'
        fprintf(statusBits(800));
        fprintf('\n');
        fprintf(statusBits(200));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(800)) + length(statusBits(200)) + 2;
    elseif hundreds == '5'
        fprintf(statusBits(400));
        fprintf('\n');
        fprintf(statusBits(100));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(100)) + length(statusBits(400)) + 2;
    elseif hundreds == '6'
        fprintf(statusBits(400));
        fprintf('\n');
        fprintf(statusBits(200));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(200)) + length(statusBits(400)) + 2;
    elseif hundreds == '3'
        fprintf(statusBits(100));
        fprintf('\n');
        fprintf(statusBits(200));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(200)) + length(statusBits(100)) + 2;
    elseif hundreds ~= '0'
        fprintf(statusBits(str2double(hundreds)*100));
        fprintf('\n');
        len_prev = len_prev + length(statusBits(str2double(hundreds)*100)) + 1;
    end
    len_prev = len_prev + 1;
    fprintf('\n');
    
   
    %{
    For collection times longer than 80 seconds SPC_test_state updates also DLL software
    counters (hardware timers count up to 80 sec). Therefore during the measurement
    SPC_get_actual_coltime or SPC_get_time_from_start calls must be done after SPC_test_state
    call.
    %}
end

