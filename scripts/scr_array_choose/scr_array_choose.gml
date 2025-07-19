function array_choose(array) {
    if (!is_array(array) || array_length(array) == 0) {
        show_debug_message("Ошибка: array_choose получил некорректный или пустой массив!");
        return -1;
    }
    var index = irandom(array_length(array) - 1);
    return array[index];
}