// Очистка ресурсов EyeTribe
if (global.__eyet_socket != -1) {
    network_destroy(global.__eyet_socket);
    global.__eyet_socket = -1;
}
buffer_delete(global.__eyet_acc);
buffer_delete(global.__eyet_send);
show_debug_message("objGaze уничтожен");