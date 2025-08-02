function scr_eyet_data(_json, _str) {
    if (_json == -1) exit;
    var _values = _json[?"values"];
    if (_values == undefined) {
        show_debug_message("EyeTribe: Некорректные данные JSON, используются запасные значения");
        left_pupil_diameter = irandom_range(15, 35);
        right_pupil_diameter = irandom_range(15, 35);
        exit;
    }
    var _frame = _values[?"frame"];
    if (_frame == undefined) {
        show_debug_message("EyeTribe: Отсутствует frame в JSON, используются запасные значения");
        left_pupil_diameter = irandom_range(15, 35);
        right_pupil_diameter = irandom_range(15, 35);
        exit;
    }
    var _time = _frame[?"time"];
    var _point1 = _frame[?"lefteye"];
    var _point2 = _frame[?"righteye"];
    if (_point1 != undefined && _point2 != undefined && ds_map_exists(_point1, "psize") && ds_map_exists(_point2, "psize")) {
        trace(_time, _point1[?"psize"], _point2[?"psize"]);
        left_pupil_diameter = _point1[?"psize"];
        right_pupil_diameter = _point2[?"psize"];
    } else {
        show_debug_message("EyeTribe: Отсутствуют данные зрачков, используются запасные значения");
        left_pupil_diameter = irandom_range(15, 35);
        right_pupil_diameter = irandom_range(15, 35);
    }
}
