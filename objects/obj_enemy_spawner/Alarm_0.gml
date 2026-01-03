if (current_enemies < max_enemies)
{
    for (var i = 0; i < (max_enemies - current_enemies); i++)
    {
		var area_index = irandom(array_length(spawn_areas) - 1);
		var area = spawn_areas[area_index];
		var x_range = area[0];
		var y_range = area[1];

		var spawn_x = irandom_range(x_range[0], x_range[1]) * 16;
		var spawn_y = irandom_range(y_range[0], y_range[1]) * 16;

        
        instance_create_layer(spawn_x, spawn_y, "Instances", enemy_to_spawn);
        current_enemies++;
    }
}

alarm[0] = irandom_range(700, 1000);