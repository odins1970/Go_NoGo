// Управление состояниями
timer += 1;

// Обработка клавиш F1 и F2 для отображения/скрытия статистики
if (keyboard_check_pressed(vk_f1)) {
    show_stats = true;
}
if (keyboard_check_pressed(vk_f2)) {
    show_stats = false;
}

if (instance_exists(objGaze)) {
    left_pupil = objGaze.left_pupil_diameter;
    right_pupil = objGaze.right_pupil_diameter;
} else {
    left_pupil = irandom_range(5, 75);
    right_pupil = irandom_range(5, 75);
	
    show_debug_message("objGaze не существует, используются случайные значения: left=" + string(left_pupil) + ", right=" + string(right_pupil));
}
left_pupil = clamp(left_pupil,12, 60);
   right_pupil = clamp (right_pupil,12, 60);

// Вычисление среднего диаметра зрачка для текущего кадра
var avg_pupil = (left_pupil + right_pupil) / 2;

// Убедимся, что в состояниях initial_wait и wait нет стимулов
if (state == "initial_wait" || state == "wait") {
    if (instance_exists(obj_stimulus)) {
        with (obj_stimulus) instance_destroy();
        show_debug_message("Удалены все экземпляры obj_stimulus в состоянии " + state + ", количество: " + string(instance_number(obj_stimulus)));
    }
}

if (state == "initial_wait") {
    // Начальное ожидание 5 секунд
    if (timer >= initial_wait_duration) {
        timer = 0;
        reaction_time_ms = 0; // Сбрасываем время реакции
        // Очищаем буферы для нового испытания
        ds_list_clear(left_pupil_buffer_wait);
        ds_list_clear(right_pupil_buffer_wait);
        ds_list_clear(left_pupil_buffer_prime_target);
        ds_list_clear(right_pupil_buffer_prime_target);
        state = "prime";
        // Создаем предшествующий стимул
        var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
        if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square) && sprite_exists(spr_black_shape)) {
            if (prime_type == 0) {
                inst.sprite_index = spr_green_circle;
            } else if (prime_type == 1) {
                inst.sprite_index = spr_red_square;
            } else {
                inst.sprite_index = spr_black_shape;
            }
            show_debug_message("Создан obj_stimulus с sprite_index=" + sprite_get_name(inst.sprite_index) + " в состоянии prime");
        } else {
            show_debug_message("Ошибка: Один или несколько спрайтов не найдены!");
            game_end();
        }
    }
} else if (state == "prime") {
    // Показ предшествующего стимула
    // Добавляем данные зрачков в буфер prime + target
    ds_list_add(left_pupil_buffer_prime_target, left_pupil);
    ds_list_add(right_pupil_buffer_prime_target, right_pupil);
    if (ds_list_size(left_pupil_buffer_prime_target) > 21) {
        ds_list_delete(left_pupil_buffer_prime_target, 0);
        ds_list_delete(right_pupil_buffer_prime_target, 0);
    }
    
    if (timer >= prime_duration) {
        timer = 0;
        reaction_time_ms = 0; // Сбрасываем время реакции
        state = "target";
        with (obj_stimulus) instance_destroy(); // Удаляем предшествующий стимул
        show_debug_message("Удалён obj_stimulus при переходе из prime в target");
        // Создаем целевой стимул
        var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
        if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square)) {
            if (stimulus_type == 0) {
                inst.sprite_index = spr_green_circle;
            } else {
                inst.sprite_index = spr_red_square;
            }
            show_debug_message("Создан obj_stimulus с sprite_index=" + sprite_get_name(inst.sprite_index) + " в состоянии target");
        } else {
            show_debug_message("Ошибка: spr_green_circle или spr_red_square не найдены!");
            game_end();
        }
    }
} else if (state == "target") {
    // Обновляем время реакции
    reaction_time_ms += delta_time / 1000; // Суммируем время в мс
    
    // Добавляем данные зрачков в буфер prime + target
    ds_list_add(left_pupil_buffer_prime_target, left_pupil);
    ds_list_add(right_pupil_buffer_prime_target, right_pupil);
    if (ds_list_size(left_pupil_buffer_prime_target) > 21) {
        ds_list_delete(left_pupil_buffer_prime_target, 0);
        ds_list_delete(right_pupil_buffer_prime_target, 0);
    }
    
    // Вычисляем current_target_duration для текущего испытания
    var current_target_duration = target_duration / 60 * 1000; // Преобразуем в мс
    
    // Обработка целевого стимула
    var key_pressed = keyboard_check_pressed(vk_space);
    var trial_result = "";
    // Вычисляем is_congruent для текущего испытания
    var current_congruent = (prime_type == stimulus_type);
    
    // Вычисляем Pupil для prime + target
 var pupil_prime_target = 0;
if (ds_list_size(left_pupil_buffer_prime_target) >= 21 && ds_list_size(right_pupil_buffer_prime_target) >= 21) {
    var temp_list = ds_list_create();
    for (var i = 0; i < 21; i++) {
        var left = ds_list_find_value(left_pupil_buffer_prime_target, i);
        var right = ds_list_find_value(right_pupil_buffer_prime_target, i);
        // Проверяем, что оба значения не undefined и являются числами
        if (!is_undefined(left) && !is_undefined(right) && is_real(left) && is_real(right)) {
            ds_list_add(temp_list, (left + right) / 2);
        } else {
            show_debug_message("Ошибка: Некорректные данные зрачков в индексе " + string(i) + ": left=" + string(left) + ", right=" + string(right));
        }
    }
    if (ds_list_size(temp_list) > 0) {
        pupil_prime_target = ds_list_median(temp_list);
    } else {
        show_debug_message("Ошибка: temp_list пуст, невозможно вычислить pupil_prime_target");
    }
    ds_list_destroy(temp_list);
}
    
    // Вычисляем Pupil для wait
    var pupil_wait = 0;
    if (ds_list_size(left_pupil_buffer_wait) >= 21) {
        var temp_list = ds_list_create();
        for (var i = 0; i < 21; i++) {
            var left = ds_list_find_value(left_pupil_buffer_wait, i);
            var right = ds_list_find_value(right_pupil_buffer_wait, i);
            ds_list_add(temp_list, (left + right) / 2);
        }
        pupil_wait = ds_list_median(temp_list);
        ds_list_destroy(temp_list);
    }
    
    // Вычисляем разницу Pupil
    var pupil_diff = pupil_prime_target - pupil_wait;
    
    if (stimulus_type == 0) { // Go-стимул (зеленый круг)
        if (key_pressed) {
            ds_list_add(rt_list, reaction_time_ms); // Сохраняем время реакции в мс
            if (current_congruent) ds_list_add(congruent_rt, reaction_time_ms);
            else ds_list_add(incongruent_rt, reaction_time_ms);
            if (last_stimulus_type != stimulus_type && last_stimulus_type != -1) {
                ds_list_add(switch_rt, reaction_time_ms);
            } else {
                ds_list_add(no_switch_rt, reaction_time_ms);
            }
            if (prime_type == 2) ds_list_add(black_shape_prime_rt, reaction_time_ms); // Сохраняем время реакции для prime_type = 2
            ds_list_add(pupil_list_prime_target, pupil_prime_target); // Сохраняем Pupil для prime + target
            correct_responses += 1;
            consecutive_correct += 1; // Увеличиваем счетчик последовательных правильных
            total_trials += 1;
            trial_result = "Correct";
            // Сохраняем данные испытания
            trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, reaction_time_ms, trial_result, pupil_wait, pupil_prime_target, pupil_diff, current_target_duration, consecutive_correct];
            trial_id += 1;
            // Воспроизведение звука при правильной реакции
            if (audio_exists(snd_correct)) {
                audio_play_sound(snd_correct, 10, false);
            } else {
                show_debug_message("Ошибка: звуковой ресурс snd_correct не найден!");
            }
            // Удаляем целевой стимул перед переходом в "wait"
            with (obj_stimulus) instance_destroy();
            show_debug_message("Удалён obj_stimulus при переходе из target в wait (Go, нажата клавиша)");
            state = "wait";
        } else if (timer >= target_duration) {
            misses += 1; // Пропуск Go-стимула
            total_trials += 1;
            trial_result = "Miss";
            // Для prime_type = 2 или prime_type = 0 время реакции равно времени показа Go-стимула
            if (prime_type == 2 || prime_type == 0) {
                reaction_time_ms = current_target_duration;
                if (prime_type == 2) ds_list_add(black_shape_prime_rt, reaction_time_ms); // Сохраняем для prime_type = 2
                ds_list_add(rt_list, reaction_time_ms); // Сохраняем в общий список RT
                if (current_congruent) ds_list_add(congruent_rt, reaction_time_ms);
                else ds_list_add(incongruent_rt, reaction_time_ms);
                if (last_stimulus_type != stimulus_type && last_stimulus_type != -1) {
                    ds_list_add(switch_rt, reaction_time_ms);
                } else {
                    ds_list_add(no_switch_rt, reaction_time_ms);
                }
            } else {
                // Для prime_type = 1 время реакции = min(reaction_time_ms, target_duration в мс)
                var max_reaction_time = target_duration / 60 * 1000; // target_duration в мс
                reaction_time_ms = min(reaction_time_ms, max_reaction_time);
            }
            ds_list_add(pupil_list_prime_target, pupil_prime_target); // Сохраняем Pupil для prime + target
            trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, reaction_time_ms, trial_result, pupil_wait, pupil_prime_target, pupil_diff, current_target_duration, consecutive_correct];
            trial_id += 1;
            consecutive_correct = 0; // Сбрасываем последовательные правильные
            // Удаляем целевой стимул перед переходом в "wait"
            with (obj_stimulus) instance_destroy();
            show_debug_message("Удалён obj_stimulus при переходе из target в wait (Go, таймер истёк)");
            state = "wait";
        }
    } else { // NoGo-стимул (красный квадрат)
        if (key_pressed) {
            false_positives += 1; // Ложное срабатывание
            total_trials += 1;
            trial_result = "False Positive";
            ds_list_add(pupil_list_prime_target, pupil_prime_target); // Сохраняем Pupil для prime + target
            trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, -1, trial_result, pupil_wait, pupil_prime_target, pupil_diff, current_target_duration];
            trial_id += 1;
            consecutive_correct = 0; // Сбрасываем последовательные правильные
            // Удаляем целевой стимул перед переходом в "wait"
            with (obj_stimulus) instance_destroy();
            show_debug_message("Удалён obj_stimulus при переходе из target в wait (NoGo, нажата клавиша)");
            state = "wait";
        } else if (timer >= target_duration) {
            correct_responses += 1; // Правильное подавление
            consecutive_correct += 1; // Увеличиваем счетчик последовательных правильных
            total_trials += 1;
            trial_result = "Suppressed";
            ds_list_add(pupil_list_prime_target, pupil_prime_target); // Сохраняем Pupil для prime + target
            trials_data[trial_id] = [trial_id, stimulus_type, prime_type, current_congruent, reaction_time_ms, trial_result, pupil_wait, pupil_prime_target, pupil_diff, current_target_duration, consecutive_correct];
            trial_id += 1;
            // Воспроизведение звука при правильной реакции
            if (audio_exists(snd_correct)) {
                audio_play_sound(snd_correct, 10, false);
            } else {
                show_debug_message("Ошибка: звуковой ресурс snd_correct не найден!");
            }
            // Удаляем целевой стимул перед переходом в "wait"
            with (obj_stimulus) instance_destroy();
            show_debug_message("Удалён obj_stimulus при переходе из target в wait (NoGo, таймер истёк)");
            state = "wait";
        }
    }
    
    // Проверка на 5 последовательных правильных ответов
    if (consecutive_correct >= 5) {
        target_duration -= 1.5; // Уменьшаем на 25 мс (1.5 шага при 60 FPS)
        if (target_duration < 1.5) target_duration = 1.5; // Минимальная длительность 25 мс
        consecutive_correct = 0; // Сбрасываем счетчик
        show_debug_message("Target duration уменьшен на 25 мс. Новый target_duration: " + string(target_duration));
    }
} else if (state == "wait") {
    // Пауза перед новым испытанием (3 секунды)
    // Добавляем данные зрачков в буфер wait
    ds_list_add(left_pupil_buffer_wait, left_pupil);
    ds_list_add(right_pupil_buffer_wait, right_pupil);
    if (ds_list_size(left_pupil_buffer_wait) > 21) {
        ds_list_delete(left_pupil_buffer_wait, 0);
        ds_list_delete(right_pupil_buffer_wait, 0);
    }
    
    if (timer >= wait_duration) {
        // Вычисляем Pupil для wait
        var pupil_wait = 0;
        if (ds_list_size(left_pupil_buffer_wait) >= 21) {
            var temp_list = ds_list_create();
            for (var i = 0; i < 21; i++) {
                var left = ds_list_find_value(left_pupil_buffer_wait, i);
                var right = ds_list_find_value(right_pupil_buffer_wait, i);
                ds_list_add(temp_list, (left + right) / 2);
            }
            pupil_wait = ds_list_median(temp_list);
            ds_list_destroy(temp_list);
        }
        ds_list_add(pupil_list_wait, pupil_wait); // Сохраняем Pupil для wait
        
        // Проверка на максимальное количество испытаний или правильных ответов
        if (total_trials >= max_trials || correct_responses >= 30) {
            var saved_filename = save_trial_data();
            with (obj_stimulus) instance_destroy(); // Удаляем все стимулы при завершении
            show_debug_message("Удалены все экземпляры obj_stimulus при завершении испытаний");
            game_end();
        }
        
        timer = 0;
        reaction_time_ms = 0; // Сбрасываем время реакции
        // Очищаем буферы для нового испытания
        ds_list_clear(left_pupil_buffer_wait);
        ds_list_clear(right_pupil_buffer_wait);
        ds_list_clear(left_pupil_buffer_prime_target);
        ds_list_clear(right_pupil_buffer_prime_target);
        state = "prime";
        // Убедимся, что нет стимулов
        with (obj_stimulus) instance_destroy();
        show_debug_message("Удалены все экземпляры obj_stimulus при переходе из wait в prime");
        
        // Генерация нового испытания
        last_stimulus_type = stimulus_type;
        stimulus_type = choose(0, 1); // Go или NoGo
        prime_type = array_choose(prime_type_weights); // Зеленый круг (40%), красный квадрат (40%) или черная фигура (20%)
        if (prime_type == 2) black_shape_prime_trials += 1; // Учет черной фигуры в prime
        is_congruent = (prime_type == stimulus_type); // Конгруэнтность для следующего испытания
        
        // Создаем предшествующий стимул
        var inst = instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_stimulus);
        if (sprite_exists(spr_green_circle) && sprite_exists(spr_red_square) && sprite_exists(spr_black_shape)) {
            if (prime_type == 0) {
                inst.sprite_index = spr_green_circle;
            } else if (prime_type == 1) {
                inst.sprite_index = spr_red_square;
            } else {
                inst.sprite_index = spr_black_shape;
            }
            show_debug_message("Создан obj_stimulus с sprite_index=" + sprite_get_name(inst.sprite_index) + " в состоянии prime");
        } else {
            show_debug_message("Ошибка: Один или несколько спрайтов не найдены!");
            game_end();
        }
    }
}

// Сохранение данных в файл при нажатии Esc
if (keyboard_check_pressed(vk_escape)) {
    var saved_filename = save_trial_data();
    with (obj_stimulus) instance_destroy(); // Удаляем все стимулы при выходе
    game_end();
}