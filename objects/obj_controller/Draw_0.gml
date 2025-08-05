if state == "wait" and timer =clamp (timer, 5, 60)
{ draw_set_color(c_yellow);
    draw_set_font(fnt_000); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    if resultat == 1
 {
	 draw_text(742, 354, "Успел  ");
 }
	if resultat == 2
 {draw_text(742, 354, "Опоздал  " );
 }
	if resultat == 3
 {draw_text(772, 354, "Поторопился  " );
}
	if resultat == 4
 {draw_text(742, 354, "Выждал  " );
	}
} 
else   {
draw_set_color(c_white);
    draw_set_font(fnt_default); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
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
        draw_text(xx, yy, "Средний размер зрачка в prime+target (пикс): " + string((avg_pupil_prime_target))); yy += spacing;
        draw_text(xx, yy, "Средняя разница размера зрачка (пикс): " + string((avg_pupil_diff))); yy += spacing;
        __trace_draw(xx, room_height - 100, 400, 0);
    }
}
draw_text(300, 400, "accurat_sum: " + string((accurat_sum)));
 
 