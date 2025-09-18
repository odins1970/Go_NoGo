if state == "wait" and timer =clamp (timer, 5, 70) and (resultat == 1 or resultat == 4) 
{     draw_set_font(fnt_000); // Убедитесь, что шрифт создан
    draw_set_color(c_white);
	draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
draw_text(room_width/2, 50, "" + string_format(round(correct_responses), 0, 0) );
}
else  {  
draw_set_color(c_gray);
    draw_set_font(fnt_default); // Убедитесь, что шрифт создан
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(room_width/2, 50, "" + string_format(round(correct_responses), 0, 0) );
}

// Отображает статистику при включенном show_stats
{
    if (show_stats)
    {
        draw_set_color(c_white);
    draw_set_font(fnt_default); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
        var xx = 1200;
        var yy = 10;
        var spacing = 20;
        draw_text(xx, yy, "Общее количество испытаний: " + string(total_trials)); yy += spacing;
        draw_text(xx, yy, "Правильные ответы: " + string(correct_responses)); yy += spacing;
        draw_text(xx, yy, "Последовательные правильные: " + string(consecutive_correct)); yy += spacing;
        draw_text(xx, yy, "Медианное время реакции (мс): " + string(round(avg_rt))); yy += spacing;
        draw_text(xx, yy, "Медианное время реакции для черной фигуры (мс): " + string(round(avg_black_shape_rt))); yy += spacing;
        draw_text(xx, yy, "Точность (%): " + string(round(accuracy))); yy += spacing;
        draw_text(xx, yy, "Ложные срабатывания: " + string(false_positives)); yy += spacing;
        draw_text(xx, yy, "Пропуски: " + string(misses)); yy += spacing;
        draw_text(xx, yy, "Go-испытания: " + string(ds_list_size(rt_list))); yy += spacing;
        draw_text(xx, yy, "NoGo-испытания: " + string(total_trials - ds_list_size(rt_list))); yy += spacing;
        draw_text(xx, yy, "Испытания с черной фигурой в прайме: " + string(black_shape_prime_trials)); yy += spacing;
        draw_text(xx, yy, "Когнитивная гибкость (мс): " + string((switch_cost))); yy += spacing;
        draw_text(xx, yy, "Контроль интерференции (мс): " + string((interference))); yy += spacing;
        draw_text(xx, yy, "Финальная длительность цели (мс): " + string((last_go_target_duration))); yy += spacing;
        draw_text(xx, yy, "Средний размер зрачка в wait (пикс): " + string((avg_pupil_wait))); yy += spacing;
        draw_text(xx, yy, "Средний размер зрачка в prime(пикс): " + string((avg_pupil_prime_target))); yy += spacing;
        draw_text(xx, yy, "Средний размер зрачка в target (пикс): " + string((avg_pupil_target))); yy += spacing;
		draw_text(xx, yy, "Средняя разница размера зрачка (пикс): " + string((avg_pupil_diff))); yy += spacing;
           }
}
if (state == "initial_wait" or state == "wait") and timer =clamp (timer, 70, 240)// маркер ожидания
{draw_set_alpha(0.9)
	draw_line_width_color(room_width/2,(room_height/2)-25,room_width/2,(room_height/2)+25,2,c_white,c_white)
draw_line_width_color ((room_width/2)-25,(room_height/2),(room_width/2)+25,(room_height/2),2,c_white,c_white)	
}

y=50
// Вывод содержимого левого буфера
draw_text(150, y, "left:");
y += line_height;
for (var i = 0; i < ds_list_size(left_pupil_buffer_wait); i++)
{
    var value = ds_list_find_value(left_pupil_buffer_wait, i);
    draw_text(170, y, ": [" + string(i) + "]: " + string(value));
    y += 20;
}

draw_text(200, 500, string (ds_list_size(left_pupil_buffer_wait)))
draw_text(200, 600, string (pupil_wait))