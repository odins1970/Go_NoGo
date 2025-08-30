// Рисует спрайт стимула в состояниях prime или target
{
    if (instance_exists(obj_controller))
    {
        if (obj_controller.state == "prime " or obj_controller.state == "target")
        {
            draw_self();
        }
    }
    else
    {
        draw_self();
    }
}
