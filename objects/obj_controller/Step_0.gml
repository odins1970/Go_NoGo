// obj_controller - Step Event
// Manages state transitions and trial logic
{
    timer += 1;

    // Handle stats display toggle
    if (keyboard_check_pressed(vk_f1))
    {
        show_stats = true;
    }
    if (keyboard_check_pressed(vk_f2))
    {
        show_stats = false;
    }
	    // Get pupil diameters
    if (instance_exists(objGaze)) 
    {
        left_pupil = clamp(gaze_raw_x, 12, 60);
        right_pupil = clamp(gaze_raw_y, 12, 60);
    }
    else
    {
        left_pupil = irandom_range(12, 60);
        right_pupil = irandom_range(12, 60);
        show_debug_message("objGaze not found, using random values: left=" + string(left_pupil) + ", right=" + string(right_pupil));
    }
    // Calculate average pupil size for current frame
    avg_pupil = (left_pupil + right_pupil) / 2;

    // Clear stimuli in wait states
    if (state == "initial_wait" || state == "wait")
    {
        if (instance_exists(obj_stimulus))
        {
            with (obj_stimulus) instance_destroy();
            show_debug_message("Cleared all obj_stimulus instances in state " + state + ", count: " + string(instance_number(obj_stimulus)));
        }
    }

    if (state == "initial_wait")
    {
        if (timer >= initial_wait_duration)
        {
            timer = 0;
            reaction_time_ms = 0;
            ds_list_clear(left_pupil_buffer_wait);
            ds_list_clear(right_pupil_buffer_wait);
            ds_list_clear(left_pupil_buffer_prime_target);
            ds_list_clear(right_pupil_buffer_prime_target);
			ds_list_clear(left_pupil_buffer_target);
            ds_list_clear(right_pupil_buffer_target);
            state = "prime";
            var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
            if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square) && sprite_exists(spr_black_shape))
            {
                if (prime_type == 0)
                {
                    inst.sprite_index = spr_green_circle;
                }
                else if (prime_type == 1)
                {
                    inst.sprite_index = spr_red_square;
                }
                else
                {
                    inst.sprite_index = spr_black_shape;
                }
                show_debug_message("Created obj_stimulus with sprite_index=" + sprite_get_name(inst.sprite_index) + " in prime state");
            }
            else
            {
                show_debug_message("Error: One or more sprites not found!");
                game_end();
            }
        }
    }
    else if (state == "prime")
    {
        ds_list_add(left_pupil_buffer_prime_target, left_pupil);
        ds_list_add(right_pupil_buffer_prime_target, right_pupil);
		
        
if (ds_list_size(left_pupil_buffer_prime_target) >= 1 && ds_list_size(right_pupil_buffer_prime_target) >= 1)
        {
            var temp_list = ds_list_create();
            var count = min(ds_list_size(left_pupil_buffer_prime_target), 15);
            for (var i = 0; i < count; i++)
            {
                var left = ds_list_find_value(left_pupil_buffer_prime_target, i);
                var right = ds_list_find_value(right_pupil_buffer_prime_target, i);
                if (is_real(left) && is_real(right))
                {
                    ds_list_add(temp_list, (left + right) / 2);
                }
                else
                {
                    show_debug_message("Error: Invalid pupil data at index " + string(i) + ": left=" + string(left) + ", right=" + string(right));
                }
            }
            if (ds_list_size(temp_list) > 0)
            {
                pupil_prime_target = ds_list_median(temp_list);
            }
            else
            {
                show_debug_message("Error: temp_list empty, cannot compute pupil_prime_target");
            }
            ds_list_destroy(temp_list);
        }

if (ds_list_size(left_pupil_buffer_prime_target) > 15)
        {
            ds_list_delete(left_pupil_buffer_prime_target, 0);
            ds_list_delete(right_pupil_buffer_prime_target, 0);
        }

        if (timer >= prime_duration)
        {
            timer = 0;
            reaction_time_ms = 0;
            state = "target";
            resultat = 0;
            with (obj_stimulus) instance_destroy();
            show_debug_message("Cleared obj_stimulus when transitioning from prime to target");
            var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
            if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square))
            {
                if (stimulus_type == 0)
                {
                    inst.sprite_index = spr_green_circle;
                }
                else
                {
                    inst.sprite_index = spr_red_square;
                }
                show_debug_message("Created obj_stimulus with sprite_index=" + sprite_get_name(inst.sprite_index) + " in target state");
            }
            else
            {
                show_debug_message("Error: spr_green_circle or spr_red_square not found!");
                game_end();
            }
        }
    }
    else if (state == "target")
    {
        reaction_time_ms += delta_time / 1000;

        ds_list_add(left_pupil_buffer_target, left_pupil);
        ds_list_add(right_pupil_buffer_target, right_pupil);
        
        var current_target_duration = (target_duration / 60) * 1000;
        var key_pressed = mouse_check_button_pressed(mb_left);
        var trial_result = "";
        var trial_result_value = 0;
        var current_congruent = (prime_type == stimulus_type);
        var black_shape_rt = -1;
        var fixed_reaction_time = reaction_time_ms;
		
               if (total_trials > 0)
        {
            accurat_sum = (correct_responses/total_trials)*100;
        }
		else
		{accurat_sum = (correct_responses/1)*100;
		}

        // Calculate median pupil for target
        if (ds_list_size(left_pupil_buffer_target) >= 1 && ds_list_size(right_pupil_buffer_target) >= 1)
        {
            var temp_list = ds_list_create();
            var count = min(ds_list_size(left_pupil_buffer_target), 15);
            for (var i = 0; i < count; i++)
            {
                var left = ds_list_find_value(left_pupil_buffer_target, i);
                var right = ds_list_find_value(right_pupil_buffer_target, i);
                if (is_real(left) && is_real(right))
                {
                    ds_list_add(temp_list, (left + right) / 2);
                }
                else
                {
                    show_debug_message("Error: Invalid pupil data at index " + string(i) + ": left=" + string(left) + ", right=" + string(right));
                }
            }
            if (ds_list_size(temp_list) > 0)
            {
                pupil_target = ds_list_median(temp_list);
            }
            else
            {
                show_debug_message("Error: temp_list empty, cannot compute pupil_target");
            }
            ds_list_destroy(temp_list);
        }
		if (ds_list_size(left_pupil_buffer_target) > 15)
        {
            ds_list_delete(left_pupil_buffer_target, 0);
            ds_list_delete(right_pupil_buffer_target, 0);
        }

        // Calculate median pupil for wait
        if (ds_list_size(left_pupil_buffer_wait) >= 1 && ds_list_size(right_pupil_buffer_wait) >= 1)
        {
            var temp_list = ds_list_create();
            var count = min(ds_list_size(left_pupil_buffer_wait), 15);
            for (var i = 0; i < count; i++)
            {
                var left = ds_list_find_value(left_pupil_buffer_wait, i);
                var right = ds_list_find_value(right_pupil_buffer_wait, i);
                if (is_real(left) && is_real(right))
                {
                    ds_list_add(temp_list, (left + right) / 2);
                }
            }
            if (ds_list_size(temp_list) > 0)
            {
                pupil_wait = ds_list_median(temp_list);
            }
            ds_list_destroy(temp_list);
        }

        // Calculate pupil difference
        var pupil_diff = ((pupil_prime_target / pupil_wait)-(pupil_target / pupil_wait));

        if (stimulus_type == 0) // Go
        {
            if (key_pressed)
            {
                ds_list_add(rt_list, fixed_reaction_time);
                if (prime_type != 2)
                {
                    if (current_congruent)
                    {
                        ds_list_add(congruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_same_stimulus, accurat_sum);
                    }
                    else
                    {
                        ds_list_add(incongruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_diff_stimulus, accurat_sum);
                    }
                }
                if (last_stimulus_type != stimulus_type && last_stimulus_type != -1)
                {
                    ds_list_add(switch_rt, fixed_reaction_time);
                    
                }
                else
                {
                    ds_list_add(no_switch_rt, fixed_reaction_time);
                   
                }
                if (prime_type == 2)
                {
                    ds_list_add(black_shape_prime_rt, fixed_reaction_time);
                    black_shape_rt = fixed_reaction_time;
                }
                ds_list_add(pupil_list_prime_target, pupil_prime_target);
				ds_list_add(pupil_list_target, pupil_target);
                correct_responses += 1;
                consecutive_correct += 1;
                resultat = 1;
                consecutive_Sum += consecutive_correct;
                total_trials += 1;
                trial_result = "Correct";
                trial_result_value = 1;
                last_go_target_duration = current_target_duration;
                trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, fixed_reaction_time, trial_result, pupil_wait, pupil_prime_target,pupil_target,pupil_diff, current_target_duration, consecutive_correct, accurat_sum_diff, trial_result_value, black_shape_rt, accurat_sum];
                trial_id += 1;
				consecutive_errors = 0;
            show_debug_message("Correct response: consecutive_errors reset to 0");
                if (audio_exists(snd_correct))
                {
                    audio_play_sound(snd_correct, 10, false);
                }
                else
                {
                    show_debug_message("Error: snd_correct audio resource not found!");
                }
                with (obj_stimulus) instance_destroy();
                show_debug_message("Cleared obj_stimulus when transitioning from target to wait (Go, key pressed)");
                state = "wait";
            }
            else if (timer >= target_duration)
            {
                misses += 1;
                total_trials += 1;
                trial_result = "Miss";
                trial_result_value = -1;
                resultat = 2;
                last_go_target_duration = current_target_duration;
                if (prime_type == 0 || prime_type == 1)
                {
                    fixed_reaction_time = clamp(current_target_duration, 0, current_target_duration);
                    ds_list_add(rt_list, fixed_reaction_time);
                    if (prime_type != 2)
                    {
                        if (current_congruent)
                        {
                            ds_list_add(congruent_rt, fixed_reaction_time);
                        ds_list_add(accurat_sum_same_stimulus, accurat_sum);
						}
                        else
                        {
                            ds_list_add(incongruent_rt, fixed_reaction_time);
							ds_list_add(accurat_sum_diff_stimulus, accurat_sum);
                        }
                    }
                    if (last_stimulus_type != stimulus_type && last_stimulus_type != -1)
                    {
                        ds_list_add(switch_rt, fixed_reaction_time);
                        
                    }
                    else
                    {
                        ds_list_add(no_switch_rt, fixed_reaction_time);
                        
                    }
                }
                if (prime_type == 2)
                {
                    fixed_reaction_time = clamp(current_target_duration, 0, current_target_duration);
                    ds_list_add(black_shape_prime_rt, fixed_reaction_time);
                    black_shape_rt = fixed_reaction_time;
                }
                ds_list_add(pupil_list_prime_target, pupil_prime_target);
				ds_list_add(pupil_list_target, pupil_target);
                trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, fixed_reaction_time, trial_result, pupil_wait, pupil_prime_target,pupil_target,pupil_diff, current_target_duration, consecutive_correct, accurat_sum_diff, trial_result_value, black_shape_rt, accurat_sum];
                trial_id += 1;
				consecutive_errors += 1;
                consecutive_correct = 0;
                consecutive_Sum += consecutive_correct;
                with (obj_stimulus) instance_destroy();
                show_debug_message("Cleared obj_stimulus when transitioning from target to wait (Go, timer expired)");
                state = "wait";
            }
        }
        else // NoGo
        {
            if (key_pressed)
            {
                ds_list_add(rt_list, fixed_reaction_time);
                if (prime_type != 2)
                {
                    if (current_congruent)
                    {
                        ds_list_add(congruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_same_stimulus, accurat_sum);
                    }
                    else
                    {
                        ds_list_add(incongruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_diff_stimulus, accurat_sum);
                    }
                }
                if (last_stimulus_type != stimulus_type && last_stimulus_type != -1)
                {
                    ds_list_add(switch_rt, fixed_reaction_time);
                    
                }
                else
                {
                    ds_list_add(no_switch_rt, fixed_reaction_time);
                    
                }
                if (prime_type == 2)
                {
                    ds_list_add(black_shape_prime_rt, fixed_reaction_time);
                    black_shape_rt = fixed_reaction_time;
                }
                ds_list_add(pupil_list_prime_target, pupil_prime_target);
				ds_list_add(pupil_list_target, pupil_target);
                false_positives += 1;
                total_trials += 1;
                trial_result = "False Positive";
                resultat = 3;
                trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, fixed_reaction_time, trial_result,pupil_wait, pupil_prime_target,pupil_target,pupil_diff, current_target_duration, consecutive_correct, accurat_sum_diff, trial_result_value, black_shape_rt, accurat_sum];
                trial_id += 1;
				consecutive_errors += 1;
                consecutive_correct = 0;
                consecutive_Sum += consecutive_correct;
                with (obj_stimulus) instance_destroy();
                show_debug_message("Cleared obj_stimulus when transitioning from target to wait (NoGo, key pressed)");
                state = "wait";
            }
            else if (timer >= target_duration)
            {
                correct_responses += 1;
                resultat = 4;
				trial_result = "Suppressed";
				consecutive_errors = 0;
                consecutive_correct += 1;
                consecutive_Sum += consecutive_correct;
                total_trials += 1;
                trial_result_value = 1;
                fixed_reaction_time = 1;
                ds_list_add(rt_list, fixed_reaction_time);
                if (prime_type != 2)
                {
                    if (current_congruent)
                    {
                        ds_list_add(congruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_same_stimulus, accurat_sum);
                    }
                    else
                    {
                        ds_list_add(incongruent_rt, fixed_reaction_time);
						ds_list_add(accurat_sum_same_stimulus, accurat_sum);
                    }
                }
                if (last_stimulus_type != stimulus_type && last_stimulus_type != -1)
                {
                    ds_list_add(switch_rt, fixed_reaction_time);
                    
                }
                else
                {
                    ds_list_add(no_switch_rt, fixed_reaction_time);
                    
                }
                if (prime_type == 2)
                {
                    ds_list_add(black_shape_prime_rt, fixed_reaction_time);
                    black_shape_rt = fixed_reaction_time;
                }
                ds_list_add(pupil_list_prime_target, pupil_prime_target);
				 ds_list_add(pupil_list_target, pupil_target);
                trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, fixed_reaction_time, trial_result, pupil_wait, pupil_prime_target, pupil_target,pupil_diff, current_target_duration, consecutive_correct, accurat_sum_diff, trial_result_value, black_shape_rt, accurat_sum];
                trial_id += 1;
                if (audio_exists(snd_correct))
                {
                    audio_play_sound(snd_correct, 10, false);
                }
                else
                {
                    show_debug_message("Error: snd_correct audio resource not found!");
                }
                with (obj_stimulus) instance_destroy();
                show_debug_message("Cleared obj_stimulus when transitioning from target to wait (NoGo, timer expired)");
                state = "wait";
            }
        }

        if (consecutive_correct > 4)
    {
        if (stimulus_type == 0)
        {
            target_duration -= 1.5;
			ntd=target_duration
			            if (target_duration < min_target_duration_go)
            {
                target_duration = min_target_duration_go;
            }
        }
		else
        { 
			if (stimulus_type ==1)
			 target_duration = 30;
            }
        
        consecutive_correct = 0;
        consecutive_Sum += consecutive_correct;
		consecutive_errors = 0;
        show_debug_message("Target duration reduced by 25 ms for stimulus_type=" + string(stimulus_type) + ". New target_duration: " + string(target_duration));
    }
	if (consecutive_correct == 0 && consecutive_errors > 4)
    {      
		if (stimulus_type == 0)
		     { 
				target_duration += 1.5; // Увеличение на 25 мс 
				ntd=target_duration
            if (target_duration > max_target_duration_go)
            {
                target_duration = max_target_duration_go;
            }
        }
        else
        {
			if (stimulus_type ==1)
            {
                target_duration = 30;
            }
        }
        consecutive_errors = 0; // Сброс счетчика ошибок после увеличения
		consecutive_correct = 0;
        consecutive_Sum += consecutive_correct;
        show_debug_message("Target duration increased due to errors: " + string(target_duration));
			 }
	}
 else if (state == "wait")
    {
        ds_list_add(left_pupil_buffer_wait, left_pupil);
        ds_list_add(right_pupil_buffer_wait, right_pupil);
        if (ds_list_size(left_pupil_buffer_wait) > 15)
        {
            ds_list_delete(left_pupil_buffer_wait, 0);
            ds_list_delete(right_pupil_buffer_wait, 0);
        }

        if (timer >= wait_duration)
        {
            if (ds_list_size(left_pupil_buffer_wait) >= 1 && ds_list_size(right_pupil_buffer_wait) >= 1)
            {
                var temp_list = ds_list_create();
                var count = min(ds_list_size(left_pupil_buffer_wait), 15);
                for (var i = 0; i < count; i++)
                {
                    var left = ds_list_find_value(left_pupil_buffer_wait, i);
                    var right = ds_list_find_value(right_pupil_buffer_wait, i);
                    if (is_real(left) && is_real(right))
                    {
                        ds_list_add(temp_list, (left + right) / 2);
                    }
                }
                if (ds_list_size(temp_list) > 0)
                {
                    pupil_wait = ds_list_median(temp_list);
                }
                ds_list_destroy(temp_list);
            }
            ds_list_add(pupil_list_wait, pupil_wait);

            if (total_trials >= max_trials || correct_responses >= 40)
            {
                var saved_filename = save_trial_data();
                with (obj_stimulus) instance_destroy();
                show_debug_message("Cleared all obj_stimulus instances at trial completion");
                game_end();
            }

            timer = 0;
            reaction_time_ms = 0;
            ds_list_clear(left_pupil_buffer_wait);
            ds_list_clear(right_pupil_buffer_wait);
            ds_list_clear(left_pupil_buffer_prime_target);
            ds_list_clear(right_pupil_buffer_prime_target);
			ds_list_clear(left_pupil_buffer_target);
            ds_list_clear(right_pupil_buffer_target);
            state = "prime";
            with (obj_stimulus) instance_destroy();
            show_debug_message("Cleared all obj_stimulus instances when transitioning from wait to prime");

            last_stimulus_type = stimulus_type;
			if total_trials == 0 or total_trials==2
			{stimulus_type =0
			}
			if total_trials == 1 
			{stimulus_type =1
			}
	     if (last_stimulus_type == 0) and total_trials > 2
            {
             stimulus_type = choose(0,1,choose(0,1,0));
            }
         if (last_stimulus_type == 1) and total_trials > 2
		 {
             stimulus_type = choose(0,1,0,0);
            }
		 			            // Set target_duration based on stimulus_type
            if (stimulus_type == 0)
            {
                target_duration = ntd; // 350 ms for Go
            }
            else
            {
                target_duration = 30; // 500 ms for NoGo
            }
			if total_trials <= 1 
			{
            prime_type = 0;			     
			}
			else 
			{
			prime_type = array_choose(prime_type_weights);
			           if (prime_type == 2)
            {
                black_shape_prime_trials += 1;
             }
			}
			is_congruent = (prime_type == stimulus_type);
			  var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
            if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square) && sprite_exists(spr_black_shape))
            {
                if (prime_type == 0)
                {
                    inst.sprite_index = spr_green_circle;
                }
                else if (prime_type == 1)
                {
                    inst.sprite_index = spr_red_square;
                }
                else
                {
                    inst.sprite_index = spr_black_shape;
                }
                show_debug_message("Created obj_stimulus with sprite_index=" + sprite_get_name(inst.sprite_index) + " in prime state");
            }
            else
            {
                show_debug_message("Error: One or more sprites not found!");
                game_end();
            }
        }
    }

    if (keyboard_check_pressed(vk_escape))
    {
        var saved_filename = save_trial_data();
        with (obj_stimulus) instance_destroy();
        game_end();
    }

    // Update statistical variables for Draw event
    if (ds_list_size(rt_list) > 0)
    {
        // Отладочный вывод содержимого rt_list
        var rt_list_str = "rt_list contents (" + string(ds_list_size(rt_list)) + "): [";
        for (var i = 0; i < ds_list_size(rt_list); i++)
        {
            rt_list_str += string(ds_list_find_value(rt_list, i));
            if (i < ds_list_size(rt_list) - 1) rt_list_str += ", ";
        }
        rt_list_str += "]";
        show_debug_message(rt_list_str);
        
        avg_rt = ds_list_median(rt_list);
    }
    else
    {
        avg_rt = -1;
    }
    if (ds_list_size(black_shape_prime_rt) > 0)
    {
        avg_black_shape_rt = ds_list_median(black_shape_prime_rt);
    }
    else
    {
        avg_black_shape_rt = -1;
    }
    if (total_trials > 0)
    {
        accuracy = correct_responses / total_trials * 100;
    }
    else
    {
        accuracy = 0;
    }
    if ds_list_size(switch_rt) > 0  
    {
         median_switch = ds_list_median(switch_rt);
	}
	if ds_list_size(no_switch_rt) > 0
	{
         median_no_switch = ds_list_median(no_switch_rt);
	}
	if median_no_switch>0 and median_switch>0
	{
    switch_cost =((median_switch/median_no_switch));
	}
	else
	{switch_cost =0
	}
      if ds_list_size(congruent_rt) > 0  
    {
         median_congruent = ds_list_median(congruent_rt);
	}
	if ds_list_size(incongruent_rt) > 0
	{
         median_incongruent = ds_list_median(incongruent_rt);
	}
	if median_incongruent > 0 and median_congruent > 0
	{

    interference = ((median_congruent / median_incongruent));

	}
	else
	{interference =0
	}
	        if (ds_list_size(accurat_sum_same_stimulus) > 0)
    {
        median_accurat_sum_same = ds_list_median(accurat_sum_same_stimulus);
    }
    else
    {
        median_accurat_sum_same = 0;
    }
    if (ds_list_size(accurat_sum_diff_stimulus) > 0)
    {
        median_accurat_sum_diff = ds_list_median(accurat_sum_diff_stimulus);
    }
    else
    {
        median_accurat_sum_diff = 0;
    }
	if median_accurat_sum_same  > 0  and median_accurat_sum_diff > 0
	{

	accurat_sum_diff =((median_accurat_sum_same / median_accurat_sum_diff));

	}
	else
	{accurat_sum_diff =0
	}
	final_target_duration = (ntd / 60 ) * 1000;
    if (ds_list_size(pupil_list_wait) > 0)
    {
        avg_pupil_wait = ds_list_median(pupil_list_wait);
    }
    else
    {
        avg_pupil_wait = 0;
    }
    if (ds_list_size(pupil_list_prime_target) > 0)
    {
        avg_pupil_prime_target = ds_list_median(pupil_list_prime_target);
    }
    else
    {
        avg_pupil_prime_target = 0;
    }
	if (ds_list_size(pupil_list_target) > 0)
    {
        avg_pupil_target = ds_list_median(pupil_list_target);
    }
    else
    {
        avg_pupil_target = 0;
    }
    avg_pupil_diff = ((avg_pupil_prime_target / avg_pupil_wait) - (avg_pupil_target / avg_pupil_wait));

}
if state == "wait" and timer =clamp (timer, 10, 50)
{sizze +=0.08
}
else
{sizze=0
}