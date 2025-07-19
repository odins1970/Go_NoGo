if audio_is_playing(snd_correct) and state == "wait"
{
draw_set_color(c_yellow);
    draw_set_font(fnt_000); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_text(room_width/2, room_height/2, " " + string_format(round(correct_responses), 0, 0) );
} else   {
draw_set_color(c_white);
    draw_set_font(fnt_default); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_text(room_width/2, 50, " " + string_format(round(correct_responses), 0, 0) );
}
// Вывод показателей в правом верхнем углу, если show_stats == true
if (show_stats) {
    // Устанавливаем настройки отрисовки
    draw_set_color(c_white);
    draw_set_font(fnt_default); // Убедитесь, что шрифт создан
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);

    // Начальные координаты
    var xx = room_width - 10;
    var yy = 10;

    // Медианное время реакции
    var avg_rt = 0;
    if (ds_list_size(rt_list) > 0) {
        avg_rt = ds_list_median(rt_list);
    }
    draw_text(xx, yy, "Медианное RT: " + string(floor(avg_rt)) + " мс");
    yy += 20;

    // Медианное время реакции для черной фигуры в prime
    var avg_black_shape_rt = 0;
    if (ds_list_size(black_shape_prime_rt) > 0) {
        avg_black_shape_rt = ds_list_median(black_shape_prime_rt);
    }
    draw_text(xx, yy, "Медианное RT (черная фигура в prime): " + string(floor(avg_black_shape_rt)) + " мс");
    yy += 20;

    // Точность
    var accuracy = 0;
    if (total_trials > 0) {
        accuracy = correct_responses / total_trials * 100;
    }
    draw_text(xx, yy, "Точность: " + string(floor(accuracy)) + "%");
    yy += 20;

    // Ложные срабатывания
    draw_text(xx, yy, "Ложные срабатывания: " + string(false_positives));
    yy += 20;

    // Пропуски
    draw_text(xx, yy, "Пропуски: " + string(misses));
    yy += 20;
	
	draw_text(xx, yy, "Последовательные правильные: " + string(consecutive_correct));
	yy += 20;

    // Испытания с черной фигурой в prime
    draw_text(xx, yy, "Контрольная подсказка (prime): " + string(black_shape_prime_trials));
    yy += 20;

    // Когнитивная гибкость
    var switch_cost = 0;
    if (ds_list_size(switch_rt) > 0 && ds_list_size(no_switch_rt) > 0) {
        var median_switch = ds_list_median(switch_rt);
        var median_no_switch = ds_list_median(no_switch_rt);
        switch_cost = median_switch - median_no_switch;
    }
    draw_text(xx, yy, "Когн. гибкость: " + string(floor(switch_cost)) + " мс");
    yy += 20;

    // Контроль интерференции
    var interference = 0;
    if (ds_list_size(congruent_rt) > 0 && ds_list_size(incongruent_rt) > 0) {
        var median_congruent = ds_list_median(congruent_rt);
        var median_incongruent = ds_list_median(incongruent_rt);
        interference = median_incongruent - median_congruent;
    }
    draw_text(xx, yy, "Контроль интерф.: " + string(floor(interference)) + " мс");
    yy += 20;

    // Текущая длительность целевого стимула
    var current_target_duration = target_duration / 60 * 1000; // Преобразуем в мс
    draw_text(xx, yy, "Текущая длительность цели: " + string(floor(current_target_duration)) + " мс");
    yy += 20;

    // Средние значения Pupil
    var avg_pupil_wait = 0;
    if (ds_list_size(pupil_list_wait) > 0) {
        avg_pupil_wait = ds_list_median(pupil_list_wait);
    }
    var avg_pupil_prime_target = 0;
    if (ds_list_size(pupil_list_prime_target) > 0) {
        avg_pupil_prime_target = ds_list_median(pupil_list_prime_target);
    }
    var avg_pupil_diff = avg_pupil_prime_target - avg_pupil_wait;
    draw_text(xx, yy, "Средний Pupil (wait): " + string(floor(avg_pupil_wait)) + " px");
    yy += 20;
    draw_text(xx, yy, "Средний Pupil (prime+target): " + string(floor(avg_pupil_prime_target)) + " px");
    yy += 20;
     draw_text(xx, yy, "Средняя разница Pupil: " + string(floor(avg_pupil_diff)) + " px");
} 

