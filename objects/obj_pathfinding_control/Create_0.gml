//create grig
grid = mp_grid_create(0, 0, room_width/16, room_height/16, 16, 16);

//add walls
mp_grid_add_instances(grid, obj_wall, 0);


depth = 3000