// Инициализация переменных
randomize();

// Переменные для стимулов
stimulus_type = 0; // 0 - Go (зеленый круг), 1 - NoGo (красный квадрат)
prime_type = 0; // 0 - зеленый круг, 1 - красный квадрат, 2 - черная фигура
prime_type_weights = [0, 0, 1, 1, 2]; // Веса: 40% зеленый, 40% красный, 20% черный
is_congruent = false; // Конгруэнтность предшествующего стимула
state = "initial_wait"; // Начальное состояние - ожидание 5 секунд
timer = 0; // Таймер для управления временем (в шагах)
reaction_time_ms = 0; // Время реакции в миллисекундах (для delta_time)
last_stimulus_type = -1; // Для отслеживания смены стимулов

// Переменные для показателей
rt_list = ds_list_create(); // Список времен реакции для Go
false_positives = 0; // Ложные срабатывания (нажатия на NoGo)
misses = 0; // Пропуски (не нажатия на Go)
total_trials = 0; // Общее количество попыток
correct_responses = 0; // Правильные ответы
consecutive_correct = 0; // Счетчик последовательных правильных ответов
congruent_rt = ds_list_create(); // Время реакции для конгруэнтных
incongruent_rt = ds_list_create(); // Время реакции для неконгруэнтных
switch_rt = ds_list_create(); // Время реакции при смене типа стимула
no_switch_rt = ds_list_create(); // Время реакции без смены
black_shape_prime_rt = ds_list_create(); // Время реакции для Go-испытаний с prime_type = 2
pupil_list_wait = ds_list_create(); // Список медианных значений Pupil для состояния wait
pupil_list_prime_target = ds_list_create(); // Список медианных значений Pupil для prime + target
left_pupil_buffer_wait = ds_list_create(); // Буфер для 21 значения левого зрачка (wait)
right_pupil_buffer_wait = ds_list_create(); // Буфер для 21 значения правого зрачка (wait)
left_pupil_buffer_prime_target = ds_list_create(); // Буфер для 21 значения левого зрачка (prime + target)
right_pupil_buffer_prime_target = ds_list_create(); // Буфер для 21 значения правого зрачка (prime + target)

// Переменные для статистики по черной фигуре в prime
black_shape_prime_trials = 0; // Количество испытаний с черной фигурой в prime_type

// Массив для хранения данных испытаний
trials_data = []; // [trial_id, stimulus_type, prime_type, is_congruent, reaction_time_ms, trial_result, pupil_wait, pupil_prime_target, pupil_diff, current_target_duration, consecutive_correct]
trial_id = 0; // Счетчик испытаний

// Переменная для отображения статистики
show_stats = false; // Отображение показателей (вкл/выкл по F1/F2)

// Тайминги (в шагах, 60 FPS = 1 секунда)
initial_wait_duration = 300; // 5 секунд для начального ожидания
prime_duration = 15; // 250 мс
target_duration = 21; // 350 мс (будет уменьшаться на 1.5 шага = 25 мс)
wait_duration = 240; // 4 секунды

// Максимальное количество испытаний
max_trials = 100;

// Проверка единственного экземпляра obj_controller
if (instance_number(obj_controller) > 1) {
    show_debug_message("Ошибка: Обнаружено несколько экземпляров obj_controller! Уничтожается текущий экземпляр.");
    instance_destroy();
    exit;
}

// Проверка наличия спрайтов
if (!sprite_exists(spr_green_circle) || !sprite_exists(spr_red_square) || !sprite_exists(spr_black_shape)) {
    show_message("Ошибка: Один или несколько спрайтов не найдены!");
    game_end();
    exit;
}