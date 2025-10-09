//switch_cost вычисляется как разница медианных значений:% median(switch_rt) - median(no_switch_rt).перключаемость 
//interference вычисляется как разница медианных значений:%   median(congruent_rt) - median(incongruent_rt) помехоустойчивость

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

    // Сохранение данных испытаний
    var trial_file = file_text_open_write(trial_filename);
    if (trial_file == -1)
    {
        show_debug_message("Ошибка: Не удалось создать файл испытаний по пути " + trial_filename + ". Пробуем сохранить в рабочей директории.");
        trial_filename = "trial_data_" + file_year + "-" + file_month + "-" + file_day + "_" + file_hour + "-" + file_minute + ".csv";
        trial_file = file_text_open_write(trial_filename);
        if (trial_file == -1)
        {
            show_debug_message("Ошибка: Не удалось создать файл испытаний в рабочей директории!");
            show_message("Ошибка: Не удалось сохранить данные испытаний в файл. Проверьте права доступа.");
            return "";
        }
    }

    // Исправление: Заменяем Consecutive Sum на AccuratSumDiff в заголовке
<<<<<<< HEAD
    file_text_write_string(trial_file, "Trial ID,Stimulus Type,Prime Type,Is Congruent,Reaction Time (ms),Result,Pupil Wait (px),Pupil Prime (px),Pupil Target (px),Pupil Difference (px),Current Target Duration (ms),consecutive_correct (concentr),accurat_sum_diff,Result Value,Black Shape Reaction Time (ms),аccurat_sum,аccurat_diff \n");
=======
    file_text_write_string(trial_file, "Trial ID,Stimulus Type,Prime Type,Is Congruent,Reaction Time (ms),Result,Pupil Wait (px),Pupil Prime (px),Pupil Target (px),Pupil Difference (px),Current Target Duration (ms),consecutive_correct (concentr),accurat_sum_diff,Result Value,Black Shape Reaction Time (ms),AccuratSum\n");
>>>>>>> 4962b73df8704a5ad517508a7b1787ee6d4ad0a6

    for (var i = 0; i < array_length(trials_data); i++)
    {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 17)
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
                reaction_time_str = string_format(trial[4], 0, 1); // Сохраняем с 2 знаками после запятой
                show_debug_message("Сохранение испытания #" + trial_id_str + ": Reaction Time = " + reaction_time_str);

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
			var pupil_target_str = "0";
            if (is_real(trial[8]) || is_int64(trial[8]))
            {
                pupil_target_str = string(round(trial[8]));
            }
            var pupil_diff_str = "0";
            if (is_real(trial[9]) || is_int64(trial[9]))
            {
                pupil_diff_str = string_format(trial[9],0,1);
            }
            var current_target_duration_str = "-";
            if (is_real(trial[10]) || is_int64(trial[10]))
            {
                current_target_duration_str = string(round(trial[10]));
                show_debug_message("Сохранение испытания #" + trial_id_str + ": Current Target Duration = " + current_target_duration_str);

            }
             var consecutive_sum_str = "0";
            if (is_real(trial[11]) || is_int64(trial[11]))
            {
                consecutive_sum_str = string_format(trial[11], 0, 1);
                show_debug_message("Сохранение испытания #" + trial_id_str + ": Consecutive_sum = " + consecutive_sum_str);
            }
			var accurat_sum_diff_str = "0";
            if (is_real(trial[12]) || is_int64(trial[12]))
            {
                accurat_sum_diff_str = string_format(trial[12], 0, 1);
            }
			            var result_value_str = "0";
            if (is_real(trial[13]) || is_int64(trial[13]))
            {
                result_value_str = string(trial[13]);
            }
				   var black_shape_rt_str = "Unknown";
            if (is_real(trial[14]) || is_int64(trial[14]))
            {
                black_shape_rt_str = string_format(trial[14], 0, 1);
            }
            var accurat_sum_str = "0";
            if (is_real(trial[15]) || is_int64(trial[15]))
            {
                accurat_sum_str = string_format(trial[15], 0, 1);
                show_debug_message("Сохранение испытания #" + trial_id_str + ": аccurat_sum = " + accurat_sum_str);
            }
<<<<<<< HEAD
			var accurat_diff_str = "0";
            if (is_real(trial[16]) || is_int64(trial[16]))
            {
                accurat_diff_str = string_format(trial[16], 0, 1);
                show_debug_message("Сохранение испытания #" + trial_id_str + ": аccurat_diff = " + accurat_diff_str);
            }
        
=======
			if (is_real(trial[16]) || is_int64(trial[16]))
            {

                aimdistans_str = string_format(trial[16], 0, 3);
                show_debug_message("Сохранение испытания #" + trial_id_str + ": AccuratSum = " + accurat_sum_str);
            }
			

>>>>>>> 4962b73df8704a5ad517508a7b1787ee6d4ad0a6
            var line = trial_id_str + "," +
                       stimulus_type_str + "," +
                       prime_type_str + "," +
                       is_congruent_str + "," +
                       reaction_time_str + "," +
                       result_str + "," +
                       pupil_wait_str + "," +
                       pupil_prime_target_str + "," +
					   pupil_target_str + "," +
                       pupil_diff_str + "," +
                       current_target_duration_str + "," +
                       consecutive_sum_str + "," +
					   accurat_sum_diff_str + "," +
                       result_value_str + "," +
                       black_shape_rt_str + "," +
<<<<<<< HEAD
                       accurat_sum_str + "," +
					   accurat_diff_str ;
=======
                       accurat_sum_str+ "," +
					   aimdistans_str;
>>>>>>> 4962b73df8704a5ad517508a7b1787ee6d4ad0a6
					   
            file_text_write_string(trial_file, line);
            file_text_writeln(trial_file);
        }
        else
        {
            show_debug_message("Ошибка: Некорректные данные испытания #" + string(i + 1) + ". Ожидалось 17 элементов, найдено " + string(array_length(trials_data[i])));
        }
    }

    file_text_close(trial_file);
    show_debug_message("Данные испытаний сохранены в " + trial_filename + ". Испытаний: " + string(array_length(trials_data)));

    // Calculate summary statistics
    var go_trials = 0;
    var nogo_trials = 0;
    var green_circle_prime_trials = 0;
    var red_square_prime_trials = 0;
    for (var i = 0; i < array_length(trials_data); i++)
    {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 17)
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

<<<<<<< HEAD
  file_text_write_string(summary_file, "Код,Общее количество испытаний (шт),Количество правильных ответов (шт),Концентрация_Серия правильных в среднем (шт),Медианное TR общее (мс),Медианное TR контрольное (мс),Точность (%),Ложные срабатывания (шт),Пропуски (шт),Испытания Go (шт),Испытания NoGo (шт),Прайм зеленый (шт),Прайм красный (шт),Прайм черная (шт),Переключаемость разница TR_медиан  между сменой и повторением стимула (ms),TR_медиан прайм Подсказка,TR_медиан прайм Помеха,Помехоустойчивость разница TR_медиан подсказка помеха ms,Порог Адаптации к стимулу (мс),Средний размер зрачка в ожидании (пикс),Средний размер зрачка в прайм (пикс),Средний размер зрачка праймцель (пикс),Разница средняя изменения зрачка (пс),Точность средняя при подсказке(%),Точность средняя при помехе(%), Помехоустойчивость разница точности Подсказка Помеха\n");
=======

  file_text_write_string(summary_file, "Код,Общее количество испытаний (шт),Количество правильных ответов (шт),Концентрация_Серия правильных в среднем (шт),Медианное TR общее (мс),Медианное TR контрольное (мс),Точность (%),Ложные срабатывания (шт),Пропуски (шт),Испытания Go (шт),Испытания NoGo (шт),Прайм зеленый (шт),Прайм красный (шт),Прайм черная (шт),Переключаемость разница TR_медиан  между сменой и повторением стимула (ms),TR_медиан прайм Подсказка,TR_медиан прайм Помеха,Помехоустойчивость разница TR_медиан подсказка помеха ms,Порог Адаптации к стимулу (мс),Средний размер зрачка в ожидании (пикс),Средний размер зрачка в прайм (пикс),Средний размер зрачка праймцель (пикс),Разница средняя изменения зрачка (пс),Точность средняя при подсказке(%),Точность средняя при помехе(%), Помехоустойчивость разница точности Подсказка Помеха\n");

>>>>>>> 4962b73df8704a5ad517508a7b1787ee6d4ad0a6
       
    var summary_line = string(IDA) + string(IDD) + "," +
                       string(total_trials) + "," +
                       string(correct_responses) + "," +
                       string(consecutive_Sum /total_trials) + "," +
                       string((avg_rt)) + "," +
                       string((avg_black_shape_rt)) + "," +
                       string((accuracy)) + "," +
                       string(false_positives) + "," +
                       string(misses) + "," +
                       string(go_trials) + "," +
                       string(nogo_trials) + "," +
                       string(green_circle_prime_trials) + "," +
                       string(red_square_prime_trials) + "," +
                       string(black_shape_prime_trials) + "," +
                       string(switch_cost) + "," +
                       string(median_congruent) + "," +
					   string(median_incongruent) + "," +
					   string((interference)) + "," +
                       string((last_go_target_duration)) + "," +
                       string((avg_pupil_wait)) + "," +
                       string((avg_pupil_prime_target)) + "," +
					   string((avg_pupil_target)) + "," +
                       string((avg_pupil_diff)) + "," +
					   string((median_accurat_sum_same)) + "," +
					   string((median_accurat_sum_diff)) + "," +
                       string((accurat_sum_diff));
					   
    file_text_write_string(summary_file, summary_line);
    file_text_writeln(summary_file);
    file_text_close(summary_file);
    show_debug_message("Summary statistics saved to " + summary_filename);
    return trial_filename;
}