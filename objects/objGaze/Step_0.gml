eyet_update();
//gaze_update(display_mouse_get_x(), display_mouse_get_y())
if  (current_time - last_data_time) > 200  and start_tracker = 1 {
	start_tracker = 0 
    instance_destroy();
	} 