// obj_controller - Create Event
// Initializes variables and trial parameters
{
    randomize();

    // Stimulus and prime variables
	
	IDA =choose( ("a"), ("b"), ("c"), ("d"), ("e"), ("f"), ("h"), ("k"), ("l"),("m"), ("n"), ("p"),("r"), ("s"),("t"), ("u"), ("f"))
	IDD = irandom(100000)
	stimulus_type = 0; // 0: Go (green circle), 1: NoGo (red square)
    prime_type = 0; // 0: green circle, 1: red square, 2: black shape
    prime_type_weights = [0,0,0,1,1,1,2]; // Weights: 40% green, 40% red, 20% black
    	is_congruent = false; // Congruency of prime and stimulus
    state = "initial_wait"; // Initial state
    timer = 0; // Timer for state transitions (in steps)
    reaction_time_ms = 0; // Reaction time in milliseconds
    last_stimulus_type = -1; // Tracks previous stimulus type
	adjusted_reaction_time = -1
	last_time = 0;

    // Statistical variables (accessible in Draw event)
    rt_list = ds_list_create(); // Reaction times for Go trials
    false_positives = 0; // False positives (keypress on NoGo)
    misses = 0; // Misses (no keypress on Go)
    total_trials = 0; // Total number of trials
    correct_responses = 0; // Correct responses
	resultat=-1
	resultat_same = 0
	resultat_diff = 0
	resultat_same_correct=0
	resultat_diff_correct=0
	consecutive_correct = 0; // Consecutive correct responses
	consecutive_errors = 0;
	consecutive_Sum=0
	consecutive_SumError=0
    congruent_rt = ds_list_create(); // Reaction times for congruent trials
    incongruent_rt = ds_list_create(); // Reaction times for incongruent trials
    switch_rt = ds_list_create(); // Reaction times with stimulus switch
    no_switch_rt = ds_list_create(); // Reaction times without switch
    black_shape_prime_rt = ds_list_create(); // Reaction times for Go trials with black shape prime
	pupil_list_wait = ds_list_create(); // Median pupil sizes in wait state
    pupil_list_prime_target = ds_list_create(); // Median pupil sizes in prime state
    pupil_list_target = ds_list_create();
	left_pupil_buffer_wait = ds_list_create(); // Buffer for 21 left pupil values (wait)
    right_pupil_buffer_wait = ds_list_create(); // Buffer for 21 right pupil values (wait)
    left_pupil_buffer_prime_target = ds_list_create(); // Buffer for 21 left pupil values (prime)
    right_pupil_buffer_prime_target = ds_list_create(); // Buffer for 21 right pupil values (prime)
    left_pupil_buffer_target = ds_list_create(); // Buffer for 21 left pupil values (target)
    right_pupil_buffer_target = ds_list_create(); // Buffer for 21 right pupil values (target)
	accurat_sum_same_stimulus = ds_list_create(); // Для stimulus_type == last_stimulus
	accurat_sum_diff_stimulus = ds_list_create(); // Для stimulus_type != last_stimulus
	black_shape_prime_trials = 0; // Trials with black shape prime
    avg_rt = -1; // Median reaction time
   	avg_black_shape_rt = -1; // Median reaction time for black shape prime
    accuracy = 0; // Accuracy percentage
    switch_cost = -1; // Cognitive flexibility (switch vs. no-switch RT)
    interference = -1; // Interference control (incongruent vs. congruent RT)
    final_target_duration = 0; // Final target duration in ms
    avg_pupil_wait = 0; // Average median pupil size in wait state
    avg_pupil_prime_target = 0; // Average median pupil size in prime+target state
    avg_pupil_target = 0;
	avg_pupil_diff = 0; // Difference in average pupil sizes
	left_pupil = 0;
	right_pupil = 0;
    avg_pupil = 0
	pupil_prime_target = 0;
	pupil_target = 0;
	pupil_wait = 0;
	pupil_diff =0
	accurat_sum=0
	accurat_diff=0
	median_accurat_sum_same = 0;
 median_accurat_sum_diff = 0;
accurat_sum_diff = 0;
median_congruent=0
median_incongruent=0
median_switch =0
median_no_switch=0
global.ppp=0
eror=0
consecutive_SumItog = 0
    // Trial data array
    trials_data = []; // [trial_id, stimulus_type, prime_type, is_congruent, reaction_time_ms, trial_result, pupil_wait, pupil_prime_target,pupil_target,pupil_diff, current_target_duration, consecutive_correct, accurat_sum_diff, result_value, black_shape_rt, accurat_sum ,accurat_diff ]
    trial_id = 0;

    // Display control
    show_stats = false; // Toggle stats display with F1/F2

    // Timing variables (60 FPS = 1 second)
    initial_wait_duration = 120; // 2 seconds
    prime_duration = 16; // 250 ms
    target_duration = 24; // Initial target duration (will be set dynamically in Step event)
    min_target_duration_go = 1.5; // Minimum target duration for Go (25 ms)
    min_target_duration_nogo = 30; // Minimum target duration for NoGo (500 ms)
	max_target_duration_go = 30; // 500 мс
   max_target_duration_nogo = 30; // 500 мс
    last_go_target_duration=400
   wait_duration = 240; // 4 seconds
    max_trials = 200; // Maximum trials
	ntd=target_duration
    line_height = 20
	
	// ИЗМЕНЕНИЕ: Переменные для независимого усреднения зрачков (буфер заполняется каждый шаг, медиана при 11 элементах, затем очистка)
    // Буфер для сбора 11 значений avg_pupil (каждый шаг)
    pupil_global_buffer = ds_list_create();
    // Отдельная переменная для хранения медианы (обновляется каждые 11 шагов)
    global_median_pupil = avg_pupil;
	
	

    // Ensure single instance of obj_controller
    if (instance_number(obj_controller) > 1)
    {
        show_debug_message("Error: Multiple instances of obj_controller detected! Destroying current instance.");
        instance_destroy();
        exit;
    }

    // Verify sprite existence
    if (!sprite_exists(spr_green_circle) || !sprite_exists(spr_red_square) || !sprite_exists(spr_black_shape))
    {
        show_message("Error: One or more sprites not found!");
        game_end();
        exit;
    }
}
