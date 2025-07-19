// Рисуем спрайт только в состояниях prime и target
if (instance_exists(obj_controller)) {
    if (obj_controller.state == "prime" || obj_controller.state == "target") {
        draw_self();
    }
} else {
    draw_self(); // На случай, если obj_controller отсутствует
}
