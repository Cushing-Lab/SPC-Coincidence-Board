function [rate_values] = fiber_couple()
    x=0;
    repeat = 0;
    while x == 0
        [rate_values, repeat] = SPC_read_rates(repeat);
        SPC_get_sync_state();
    end
end

