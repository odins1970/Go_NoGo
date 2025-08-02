// obj_controller - CleanUp Event
// Clean up data structures to prevent memory leaks
{
    ds_list_destroy(left_pupil_buffer_wait);
    ds_list_destroy(right_pupil_buffer_wait);
    ds_list_destroy(left_pupil_buffer_prime_target);
    ds_list_destroy(right_pupil_buffer_prime_target);
    ds_list_destroy(pupil_list_wait);
    ds_list_destroy(pupil_list_prime_target);
    ds_list_destroy(rt_list);
    ds_list_destroy(black_shape_prime_rt);
    ds_list_destroy(switch_rt);
    ds_list_destroy(no_switch_rt);
    ds_list_destroy(congruent_rt);
    ds_list_destroy(incongruent_rt);
}
