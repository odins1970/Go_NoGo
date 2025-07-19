function scr_eyet_then(_success) {
    if (_success) {
        trace("Connected!");
        show_debug_message("EyeTribe: Соединение установлено");
    } else {
        trace("Failed to connect!");
        show_debug_message("EyeTribe: Не удалось установить соединение");
    }
}
