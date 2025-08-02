// Проверка доступности функции eyet_async
eyet_async();

// Уничтожаем objGaze, если соединение не удалось
if (async_load[?"id"] == global.__eyet_socket && async_load[?"type"] == network_type_non_blocking_connect) {
    if (!async_load[?"succeeded"]) {
        show_debug_message("EyeTribe: Асинхронное соединение не удалось, уничтожается objGaze");
        instance_destroy();
    }
}


