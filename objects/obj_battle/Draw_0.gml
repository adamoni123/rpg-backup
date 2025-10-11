// draw background
draw_sprite(spr_battle_background_temp, 0, x, y)

// draw units in depth order
var unit_with_current_turn = unit_turn_order[turn].id;
for (i = 0; i < array_length(unit_turn_order); i++)
{
	with (unit_render_order[i])
	{
		draw_self();
	}
}


// draw ui boxes
draw_sprite_stretched(spr_box, 0, x + 75, y + 146, 213, 70);
draw_sprite_stretched(spr_box, 0, x, y + 146, 74, 70);


#macro COLUMN_ENEMY 15
#macro COLUMN_NAME 90
#macro COLUMN_HP 145
#macro COLUMN_MP 210


draw_set_font(fn_secondary);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_grey);
draw_text(x + COLUMN_ENEMY, y+146, "ENEMY");
draw_text(x + COLUMN_NAME, y+146, "NAME");
draw_text(x + COLUMN_HP, y+146, "HP");
draw_text(x + COLUMN_MP, y+146, "MP");


draw_set_font(fn_main);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
var _draw_limit = 3;
var _drawn = 0;
for (var i = 0; (i < array_length(enemy_units)) && (_drawn < _draw_limit); i++)
{
	var _char = enemy_units[i];
	if (_char.hp > 0)
	{
		_drawn++;
		draw_set_halign(fa_left);
		draw_set_color(c_white);
		if (_char.id == unit_with_current_turn) draw_set_colour(c_yellow);
		draw_text(x + COLUMN_ENEMY, y + 156 + (i * 12), _char.name);
	}
}

for (var i = 0; i < array_length(party_units); i++)
{
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	var _char = party_units[i];
	if (_char.id == unit_with_current_turn) draw_set_colour(c_yellow);
	if (_char.hp <= 0) draw_set_color(c_red);
	draw_text(x + COLUMN_NAME, y + 156 + (i * 12), _char.name);
	draw_set_halign(fa_right);
	
	draw_set_colour(c_white);
	if (_char.hp < (_char.max_hp * 0.5)) draw_set_color(c_orange);
	if (_char.hp <= 0) draw_set_colour(c_red);
	draw_text(x + COLUMN_HP + 50, y + 156 + (i * 12), string(_char.hp) + "/" + string(_char.max_hp));
	
	draw_set_color(c_white);
	if (_char.mp < (_char.mp * 0.5)) draw_set_color(c_orange);
	draw_text(x + COLUMN_MP + 50, y + 156 + (i * 12), string(_char.mp) + "/" + string(_char.max_mp));
	
	draw_set_color(c_white);
}

// draw target cursor
if (cursor.active)
{
	with (cursor)
	{
		if (active_target != noone)
		{
			if (!is_array(active_target))
			{
				draw_sprite(spr_pointer, 0, active_target.x, active_target.y);
			}
			else
			{
				draw_set_alpha(sin(get_timer()/50000)+1);
				for (var i = 0; i < array_length(active_target); i++)
				{
					draw_sprite(spr_pointer, 0, active_target[i].x, active_target[i].y)
				}
				draw_set_alpha(1.0);
			}
		}
	}
}
			








