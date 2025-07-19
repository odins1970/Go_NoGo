function ds_list_median(list) {
    var size = ds_list_size(list);
    if (size == 0) return 0;
    
    // Создаем временный список и копируем в него данные
    var temp_list = ds_list_create();
    for (var i = 0; i < size; i++) {
        ds_list_add(temp_list, ds_list_find_value(list, i));
    }
    
    // Сортируем временный список
    ds_list_sort(temp_list, true);
    
    // Вычисляем медиану
    var med_value;
    if (size % 2 == 0) {
        // Четное количество элементов: среднее двух средних
        var mid1 = ds_list_find_value(temp_list, size / 2 - 1);
        var mid2 = ds_list_find_value(temp_list, size / 2);
        med_value = (mid1 + mid2) / 2;
    } else {
        // Нечетное количество элементов: средний элемент
        med_value = ds_list_find_value(temp_list, size div 2);
    }
    
    // Очищаем временный список
    ds_list_destroy(temp_list);
    return med_value;
}