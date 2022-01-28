% Board Initialization
[SPCModInfo, SPC_parameters, SPC_EEP_Data, INIparameters, SPC_mem_info, page_size] = Initialize_Board();

%%
clc;
repeat = 1;
while repeat == 1
    [rate_values, repeat] = SPC_read_rates(repeat);
end