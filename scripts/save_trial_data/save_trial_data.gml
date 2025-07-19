//когнитивная гибкость Разница среднего RT при смене типа стимула (Go  NoGo) и без смены.
//Контроль интерференции Разница среднего RT между неконгруэнтными и конгруэнтными предшествующими стимулами.

function save_trial_data() {
    var directory = "C:\\Test_GNO\\";
    var filename = "";
    var file_year, file_month, file_day, file_hour, file_minute;
    
    // Получаем текущую дату и время
    var current_datetime = date_current_datetime();
    file_year = string_format(date_get_year(current_datetime), 4, 0);
    file_month = string_format(date_get_month(current_datetime), 2, 0);
    file_day = string_format(date_get_day(current_datetime), 2, 0);
    file_hour = string_format(date_get_hour(current_datetime), 2, 0);
    file_minute = string_format(date_get_minute(current_datetime), 2, 0);
    filename = directory + "trial_data_" + file_year + "-" + file_month + "-" + file_day + "_" + file_hour + "-" + file_minute + ".csv";
    show_debug_message("Формирование имени файла: " + filename);
    
    // Создаем директорию, если она не существует
    if (!directory_exists(directory)) {
        directory_create(directory);
        show_debug_message("Директория создана: " + directory);
    }
    
    // Проверяем, можем ли записать файл
    var file = file_text_open_write(filename);
    if (file == -1) {
        show_debug_message("Ошибка: Не удалось создать файл в " + filename + ". Пробуем сохранить в рабочую директорию.");
        filename = "trial_data_" + file_year + "-" + file_month + "-" + file_day + "_" + file_hour + "-" + file_minute + ".csv";
        file = file_text_open_write(filename);
        if (file == -1) {
            show_debug_message("Ошибка: Не удалось создать файл в рабочей директории!");
            show_message("Ошибка: Не удалось сохранить данные в файл. Проверьте права доступа.");
            return "";
        }
    }
    
    // Заголовок таблицы испытаний
    file_text_write_string(file, "Trial ID,Stimulus Type,Prime Type,Is Congruent,Reaction Time (ms),Result,Pupil Wait (px),Pupil Prime+Target (px),Pupil Difference (px),Current Target Duration (ms),Consecutive Correct\n");
    
    // Записываем данные испытаний
    for (var i = 0; i < array_length(trials_data); i++) {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 11) {
            var trial = trials_data[i];
            // Форматируем значения, заменяя undefined или невалидные значения
            var trial_id = "0";
            if (is_real(trial[0]) || is_int64(trial[0])) {
                trial_id = string(trial[0]);
            }
            var stimulus_type = "0";
            if (is_real(trial[1]) || is_int64(trial[1])) {
                stimulus_type = string(trial[1]);
            }
            var prime_type = "0";
            if (is_real(trial[2]) || is_int64(trial[2])) {
                prime_type = string(trial[2]);
            }
            var is_congruent = "0";
            if (is_bool(trial[3]) || is_real(trial[3])) {
                is_congruent = string(trial[3]);
            }
            var reaction_time = "-1";
            if (is_real(trial[4]) || is_int64(trial[4])) {
                reaction_time = string((trial[4]));
            }
            var result = "Unknown";
            if (is_string(trial[5])) {
                result = trial[5];
            }
            var pupil_wait = "0";
            if (is_real(trial[6]) || is_int64(trial[6])) {
                pupil_wait = string((trial[6]));
            }
            var pupil_prime_target = "0";
            if (is_real(trial[7]) || is_int64(trial[7])) {
                pupil_prime_target = string((trial[7]));
            }
            var pupil_diff = "0";
            if (is_real(trial[8]) || is_int64(trial[8])) {
                pupil_diff = string((trial[8]));
            }
            var current_target_duration = "0";
            if (is_real(trial[9]) || is_int64(trial[9])) {
                current_target_duration = string(floor(trial[9]));
            }
            var consecutive_correct_value = "0";
            if (is_real(trial[10]) || is_int64(trial[10])) {
                consecutive_correct_value = string(trial[10]);
            }
            
            var line = trial_id + "," +
                       stimulus_type + "," +
                       prime_type + "," +
                       is_congruent + "," +
                       reaction_time + "," +
                       result + "," +
                       pupil_wait + "," +
                       pupil_prime_target + "," +
                       pupil_diff + "," +
                       current_target_duration + "," +
                       consecutive_correct_value;
            file_text_write_string(file, line);
            file_text_writeln(file);
        } else {
            show_debug_message("Ошибка: Некорректные данные испытания #" + string(i) + ". Пропущено.");
        }
    }
    
    // Пустая строка для разделения
    file_text_writeln(file);
    
    // Подсчет статистики по stimulus_type и prime_type
    var go_trials = 0; // Количество Go-испытаний (stimulus_type = 0)
    var nogo_trials = 0; // Количество NoGo-испытаний (stimulus_type = 1)
    var green_circle_prime_trials = 0; // Количество prime_type = 0
    var red_square_prime_trials = 0; // Количество prime_type = 1
    var black_shape_prime_trials_value = 0; // Значение по умолчанию
    if (variable_instance_exists(id, "black_shape_prime_trials")) {
        black_shape_prime_trials_value = black_shape_prime_trials;
    } else {
        show_debug_message("Предупреждение: black_shape_prime_trials не инициализирована, используется значение 0");
    }
    var total_trials_value = 0;
    if (variable_instance_exists(id, "total_trials")) {
        total_trials_value = total_trials;
    } else {
        show_debug_message("Предупреждение: total_trials не инициализирована, используется значение 0");
    }
    var correct_responses_value = 0;
    if (variable_instance_exists(id, "correct_responses")) {
        correct_responses_value = correct_responses;
    } else {
        show_debug_message("Предупреждение: correct_responses не инициализирована, используется значение 0");
    }
    var consecutive_correct_value = 0;
    if (variable_instance_exists(id, "consecutive_correct")) {
        consecutive_correct_value = consecutive_correct;
    } else {
        show_debug_message("Предупреждение: consecutive_correct не инициализирована, используется значение 0");
    }
    
    for (var i = 0; i < array_length(trials_data); i++) {
        if (is_array(trials_data[i]) && array_length(trials_data[i]) >= 11) {
            var trial = trials_data[i];
            if (trial[1] == 0) go_trials += 1;
            else if (trial[1] == 1) nogo_trials += 1;
            if (trial[2] == 0) green_circle_prime_trials += 1;
            else if (trial[2] == 1) red_square_prime_trials += 1;
        }
    }
    
    // Записываем итоговые показатели
    var avg_rt = 0;
    if (ds_list_size(rt_list) > 0) {
        avg_rt = ds_list_median(rt_list);
    }
    var avg_black_shape_rt = 0;
    if (ds_list_size(black_shape_prime_rt) > 0) {
        avg_black_shape_rt = ds_list_median(black_shape_prime_rt);
    }
    var accuracy = 0;
    if (total_trials_value > 0) {
        accuracy = correct_responses_value / total_trials_value * 100;
    }
    var switch_cost = 0;
    if (ds_list_size(switch_rt) > 0 && ds_list_size(no_switch_rt) > 0) {
        var median_switch = ds_list_median(switch_rt);
        var median_no_switch = ds_list_median(no_switch_rt);
        switch_cost = median_switch - median_no_switch;
    }
    var interference = 0;
    if (ds_list_size(congruent_rt) > 0 && ds_list_size(incongruent_rt) > 0) {
        var median_congruent = ds_list_median(congruent_rt);
        var median_incongruent = ds_list_median(incongruent_rt);
        interference = median_incongruent - median_congruent;
    }
    var final_target_duration = target_duration / 60 * 1000; // Преобразуем target_duration в мс
    var avg_pupil_wait = 0;
    if (ds_list_size(pupil_list_wait) > 0) {
        avg_pupil_wait = ds_list_median(pupil_list_wait);
    }
    var avg_pupil_prime_target = 0;
    if (ds_list_size(pupil_list_prime_target) > 0) {
        avg_pupil_prime_target = ds_list_median(pupil_list_prime_target);
    }
    var avg_pupil_diff = avg_pupil_prime_target - avg_pupil_wait;
    
    file_text_write_string(file, "Summary Statistics\n");
    file_text_write_string(file, "Total Trials," + string(total_trials_value) + "\n");
    file_text_write_string(file, "Correct Responses," + string(correct_responses_value) + "\n");
    file_text_write_string(file, "Consecutive Correct," + string(consecutive_correct_value) + "\n");
    file_text_write_string(file, "Median RT (ms)," + string((avg_rt)) + "\n");
    file_text_write_string(file, "Control  RT Black (ms)," + string(floor(avg_black_shape_rt)) + "\n");
    file_text_write_string(file, "Accuracy (%)," + string((accuracy)) + "\n");
    file_text_write_string(file, "False Positives," + string(false_positives) + "\n");
    file_text_write_string(file, "Misses," + string(misses) + "\n");
    file_text_write_string(file, "number Go Trials (Stimulus 0)," + string(go_trials) + "\n");
    file_text_write_string(file, "number NoGo Trials (Stimulus 1)," + string(nogo_trials) + "\n");
    file_text_write_string(file, "number Green  Prime  (Prime  0)," + string(green_circle_prime_trials) + "\n");
    file_text_write_string(file, "number Red  Prime  (Prime  1)," + string(red_square_prime_trials) + "\n");
    file_text_write_string(file, "number Black  Prime  (Prime  2)," + string(black_shape_prime_trials_value) + "\n");
    file_text_write_string(file, "Cognitive Flexibility (ms)," + string((switch_cost)) + "\n");
    file_text_write_string(file, "Interference Control (ms)," + string((interference)) + "\n");
    file_text_write_string(file, "Final Target Duration (ms)," + string((final_target_duration)) + "\n");
    file_text_write_string(file, "Average Pupil Wait (px)," + string((avg_pupil_wait)) + "\n");
    file_text_write_string(file, "Average Pupil Prime+Target (px)," + string((avg_pupil_prime_target)) + "\n");
    file_text_write_string(file, "Average Pupil Difference (px)," + string((avg_pupil_diff)) + "\n");
    
    file_text_close(file);
    show_debug_message("Данные сохранены в " + filename + ". Испытаний: " + string(array_length(trials_data)));
            
    return filename;
}