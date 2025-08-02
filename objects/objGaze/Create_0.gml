// Инициализация отладочного лога
__trace_init(32);

// Инициализация переменных для диаметров зрачков
left_pupil_diameter = 25; // Начальное значение для левого зрачка (в пикселях)
right_pupil_diameter = 25; // Начальное значение для правого зрачка (в пикселях)

// Диапазон для ограничения диаметров зрачков
min_pupil_size = 12; // Минимальный диаметр зрачка
max_pupil_size = 60; // Максимальный диаметр зрачка

// Проверка единственного экземпляра objGaze
if (instance_number(objGaze) > 1) {
    show_debug_message("Ошибка: Обнаружено несколько экземпляров objGaze! Уничтожается текущий экземпляр.");
    instance_destroy();
    exit;
}

// Инициализация EyeTribe
gaze_init();
network_set_config(network_config_use_non_blocking_socket, 1);
network_set_config(network_config_connect_timeout, 7000);
if (eyet_init("localhost", 6555, scr_eyet_data, true, scr_eyet_then)) {
    trace("Connecting...");
    show_debug_message("EyeTribe: Соединение устанавливается");
} else 
    trace("Failed to start connecting");
  {  show_debug_message("EyeTribe: Не удалось установить соединение");
    instance_destroy(); // Уничтожаем objGaze при немедленной неудаче
}

