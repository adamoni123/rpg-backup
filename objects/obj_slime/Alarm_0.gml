path_delete(path);
path = path_add();

target_x = x + random_range(-20, 20);
target_y = y + random_range(-20, 20);

mp_grid_path(obj_pathfinding_control.grid, path, x, y, target_x, target_y, 1);

path_start(path, 1, path_action_stop, false);

alarm_set(0, random(450))