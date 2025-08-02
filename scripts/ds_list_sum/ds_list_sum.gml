function ds_list_sum(list) {
    var sum = 0;
    for (var i = 0; i < ds_list_size(list); i++) {
        sum += ds_list_find_value(list, i);
    }
    return sum;
}