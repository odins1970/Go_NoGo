__trace_init(32);
gaze_init();
network_set_config(network_config_use_non_blocking_socket, 1);
network_set_config(network_config_connect_timeout, 7000);
if (eyet_init("localhost", 6555, scr_eyet_data, true, scr_eyet_then)) {
trace("Connecting...");
} else trace("Failed to start connecting")
last_data_time = current_time;
start_tracker = 1 


