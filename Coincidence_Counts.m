% Board Initialization
[SPCModInfo, SPC_parameters, SPC_EEP_Data, INIparameters, SPC_mem_info, page_size] = Initialize_Board();

%%
SPC_parameters = SPC_set_parameter('sync_zc_level', .76);
SPC_parameters = SPC_set_parameter('sync_threshold', 0);
SPC_parameters = SPC_set_parameter('sync_freq_div', 2);

SPC_parameters = SPC_set_parameter('cfd_limit_low', -5.88);
SPC_parameters = SPC_set_parameter('cfd_zc_level', -5.29);

SPC_get_sync_state();
%%
fiber_couple();
%%
SPC_get_sync_state();