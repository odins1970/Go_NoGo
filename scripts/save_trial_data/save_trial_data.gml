//switch_cost вычисляется как разница медианных значений: median(switch_rt) - median(no_switch_rt).
//interference вычисляется как разница медианных значений: median(incongruent_rt) - median(congruent_rt)

// save_trial_data
// Saves trial data and summary statistics to separate CSV files
function save_trial_data()
{
    var directory = "C:\\Test_GNO\\";
    var trial_filename = "";
    var summary_filename = "";
    var file_year, file_month, file_day, file_hour, file_minute;

    var current_datetime = date_current_datetime();
    file_year = string_format(date_get_year(current_datetime), 4, 0);
    file_month = string_format(date_get_month(current_datetime), 2, 0);
    file_day = string_format(date_get_day(current_datetime), 2, 0);
    file_hour = string_format(date_get_hour(current_datetime), 2, 0);
    file_minute = string_format(date_get_minute(current_datetime), 2, 0);
    trial_filename = directory + "trial_data " + file_year + "-" + file_month + "-" + file_day + "_  " + file_hour + "-" + file_minute + ".csv";
    summary_filename = directory + "summary_stats " + file_year + "-" + file_month + "-" + file_day + "_  " + file_hour + "-" + file_minute + ".csv";
    show_debug_message("Generating trial filename: " + trial_filename);
    show_debug_message("Generating summary filename: " + summary_filename);

    if (!directory_exists(directory))
    {
        directory_create(directory);
        show_debug_message("Directory created: " + directory);
    }

    // Save trial data
    var trial_file = file_text_open_write(trial_filename);
    if (trial_file == -1)
    {
        show_debug_message("Error: Could not create trial file at " + trial_filename + ". Attempting to save in working directory.");
        trial_filename = "trial_data_" + file_year + "-" + file_month + "-" + file_day + "_" + file_hour + "-" + file_minute + ".csv";
        trial_file = file_text_open_write(trial_filename);
        if (trial_file == -1)
        {
            show_debug_message("Error: Could not create trial file in working directory!");
            show_message("Error: Could not save trial data to file. Check permissions.");
            return "";
        }
    }

    file_text_write_string(trial_file, "Trial ID,Stimulus Type,Prime Type,Is Congruent,Reaction Time (ms),Result,Pupil Wait (px),Pupil Prime+Target (px),Pupil Difference (px),Current Target Duration (ms),Consecutive Correct,Consecutive Sum,Result Value,Black Shape Reaction Time (ms),AccuratSum\n");

    for (var i = 0; i < array_length(trials_data); i++)
    {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 15) // Проверяем длину массива
        {
            var trial = trials_data[i];
            var trial_id_str = "0";
            if (is_real(trial[0]) || is_int64(trial[0]))
            {
                trial_id_str = string(trial[0]);
            }
            var stimulus_type_str = "0";
            if (is_real(trial[1]) || is_int64(trial[1]))
            {
                stimulus_type_str = string(trial[1]);
            }
            var prime_type_str = "0";
            if (is_real(trial[2]) || is_int64(trial[2]))
            {
                prime_type_str = string(trial[2]);
            }
            var is_congruent_str = "0";
            if (is_bool(trial[3]) || is_real(trial[3]))
            {
                is_congruent_str = string(trial[3]);
            }
            var reaction_time_str = "-";
            if (is_real(trial[4]) || is_int64(trial[4]))
            {
                reaction_time_str = string(round(trial[4]));
                if (trial[5] == "Suppressed" && trial[4] == -1)
                {
                    show_debug_message("Warning: Suppressed trial #" + trial_id_str + " has Reaction Time = -1, expected 500 - reaction_time_ms");
                }
            }
            var result_str = "Unknown";
            if (is_string(trial[5]))
            {
                result_str = string(trial[5]);
            }
            var pupil_wait_str = "0";
            if (is_real(trial[6]) || is_int64(trial[6]))
            {
                pupil_wait_str = string(round(trial[6]));
            }
            var pupil_prime_target_str = "0";
            if (is_real(trial[7]) || is_int64(trial[7]))
            {
                pupil_prime_target_str = string(round(trial[7]));
            }
            var pupil_diff_str = "0";
            if (is_real(trial[8]) || is_int64(trial[8]))
            {
                pupil_diff_str = string(round(trial[8]));
            }
            var current_target_duration_str = "-";
            if ((is_real(trial[1]) || is_int64(trial[1])) && trial[1] == 0 && (is_real(trial[9]) || is_int64(trial[9])))
            {
                current_target_duration_str = string(round(trial[9]));
            }
            var consecutive_correct_str = "0";
            if (is_real(trial[10]) || is_int64(trial[10]))
            {
                consecutive_correct_str = string(trial[10]);
            }
            var consecutive_sum_str = "0";
            if (is_real(trial[11]) || is_int64(trial[11]))
            {
                consecutive_sum_str = string(trial[11]);
            }
            var result_value_str = "0";
            if (is_real(trial[12]) || is_int64(trial[12]))
            {
                result_value_str = string(trial[12]);
            }
            var black_shape_rt_str = "-";
            if (is_real(trial[13]) || is_int64(trial[13]))
            {
                black_shape_rt_str = string(round(trial[13]));
            }
            var accurat_sum_str = "0";
            if (is_real(trial[14]) || is_int64(trial[14]))
            {
                accurat_sum_str = string(trial[14]);
            }

            var line = trial_id_str + "," +
                       stimulus_type_str + "," +
                       prime_type_str + "," +
                       is_congruent_str + "," +
                       reaction_time_str + "," +
                       result_str + "," +
                       pupil_wait_str + "," +
                       pupil_prime_target_str + "," +
                       pupil_diff_str + "," +
                       current_target_duration_str + "," +
                       consecutive_correct_str + "," +
                       consecutive_sum_str + "," +
                       result_value_str + "," +
                       black_shape_rt_str + "," +
                       accurat_sum_str;
            file_text_write_string(trial_file, line);
            file_text_writeln(trial_file);
        }
        else
        {
            show_debug_message("Error: Invalid trial data at #" + string(i + 1) + ". Expected 15 elements, found " + string(array_length(trials_data[i])));
        }
    }

    file_text_close(trial_file);
    show_debug_message("Trial data saved to " + trial_filename + ". Trials: " + string(array_length(trials_data)));

    // Calculate summary statistics
    var go_trials = 0;
    var nogo_trials = 0;
    var green_circle_prime_trials = 0;
    var red_square_prime_trials = 0;
    for (var i = 0; i < array_length(trials_data); i++)
    {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 15)
        {
            var trial = trials_data[i];
            if (trial[1] == 0)
            {
                go_trials += 1;
            }
            else if (trial[1] == 1)
            {
                nogo_trials += 1;
            }
            if (trial[2] == 0)
            {
                green_circle_prime_trials += 1;
            }
            else if (trial[2] == 1)
            {
                red_square_prime_trials += 1;
            }
        }
    }

    // Log contents of rt_list and black_shape_prime_rt for debugging
    var rt_list_str = "rt_list contents (" + string(ds_list_size(rt_list)) + "): [";
    for (var i = 0; i < ds_list_size(rt_list); i++)
    {
        rt_list_str += string(ds_list_find_value(rt_list, i));
        if (i < ds_list_size(rt_list) - 1) rt_list_str += ", ";
    }
    rt_list_str += "]";
    show_debug_message(rt_list_str);
    
    var black_shape_rt_str = "black_shape_prime_rt contents (" + string(ds_list_size(black_shape_prime_rt)) + "): [";
    for (var i = 0; i < ds_list_size(black_shape_prime_rt); i++)
    {
        black_shape_rt_str += string(ds_list_find_value(black_shape_prime_rt, i));
        if (i < ds_list_size(black_shape_prime_rt) - 1) black_shape_rt_str += ", ";
    }
    black_shape_rt_str += "]";
    show_debug_message(black_shape_rt_str);

    // Save summary statistics to separate file
    var summary_file = file_text_open_write(summary_filename);
    if (summary_file == -1)
    {
        show_debug_message("Error: Could not create summary file at " + summary_filename + ". Attempting to save in working directory.");
        summary_filename = "summary_stats_" + file_year + "-" + file_month + "-" + file_day + "_" + file_hour + "-" + file_minute + ".csv";
        summary_file = file_text_open_write(summary_filename);
        if (summary_file == -1)
        {
            show_debug_message("Error: Could not create summary file in working directory!");
            show_message("Error: Could not save summary data to file. Check permissions.");
            return trial_filename;
        }
    }

    // Write header row with Russian column names and units
    file_text_write_string(summary_file, "Код,Общее количество испытаний (шт),Количество правильных ответов (шт),Серия правильных в среднем (шт),Медианное TR (мс),Медианное TR контрольное (мс),Точность (%),Ложные срабатывания (шт),Пропуски (шт),Испытания Go (шт),Испытания NoGo (шт),Прайм зеленый (шт),Прайм красный (шт),Прайм черная (шт),Разница TR_медиан между сменой и повторением стимула (мс),Разница TR_медиан между прайм помеха-подсказка (мс),Финальная длительность цели Go (мс),Средний размер зрачка в ожидании (пикс),Средний размер зрачка в прайм+цель (пикс),Сила изменений зрачка (пикс),AccuratSum (Разница_медиан Точности между прайм помеха-подсказка )(%)\n");

    // Write data row
    var summary_line = string(IDA) + string(IDD) + "," +
                       string(total_trials) + "," +
                       string(correct_responses) + "," +
                       string(consecutive_Sum / total_trials) + "," +
                       string(round(avg_rt)) + "," +
                       string(round(avg_black_shape_rt)) + "," +
                       string(round(accuracy)) + "," +
                       string(false_positives) + "," +
                       string(misses) + "," +
                       string(go_trials) + "," +
                       string(nogo_trials) + "," +
                       string(green_circle_prime_trials) + "," +
                       string(red_square_prime_trials) + "," +
                       string(black_shape_prime_trials) + "," +
                       string(round(switch_cost)) + "," +
                       string(round(interference)) + "," +
                       string(round(last_go_target_duration)) + "," +
                       string(round(avg_pupil_wait)) + "," +
                       string(round(avg_pupil_prime_target)) + "," +
                       string(round(avg_pupil_diff)) + "," +
                       string(round(accurat_sum_diff));
    file_text_write_string(summary_file, summary_line);
    file_text_writeln(summary_file);

    file_text_close(summary_file);
    show_debug_message("Summary statistics saved to " + summary_filename);

    return trial_filename;
}