instance_deactivate_all(true);
audio_pause_sound(snd_town_theme);
audio_play_sound(snd_battle_start, 1, true);

units = [];
turn = 0;
unit_turn_order = [];
unit_render_order = [];
turn_count = 0;
round_count = 0;
battle_wait_time_frames = 30;
battle_wait_time_remaining = 0;
current_user = noone;
current_action = -1;
current_targets = noone;

cursor = 
{
	active_user: noone,
	active_target: noone,
	active_action: -1,
	target_side: -1,
	target_index: 0,
	target_all: false,
	confirm_delay: 0,
	active: false
};

// make enemies
for (i = 0; i < array_length(enemies); i++)
{
	enemy_units[i] = instance_create_depth
		(
		x + 220 + (i * 13), 
		y + 54 + ( i * 25 ), 
		depth-10,
		obj_battle_unit_enemy, 
		enemies[i]
		);
		
		array_push(units, enemy_units[i]);
		// show_debug_message("enemy made")
}

// make party
for (i = 0; i < array_length(global.party); i++)
{
	party_units[i] = instance_create_depth
		(
		x + 65 + (i * 10), 
		y + 80 + (i * 20), 
		depth - 10, 
		obj_battle_unit_PC, 
		global.party[i]
		);
		
		array_push(units, party_units[i]);
		// show_debug_message("party made")
}

// shuffle turn order
unit_turn_order = array_shuffle(units);

// get render order
refresh_render_order = function()
{
	unit_render_order = [];
	array_copy(unit_render_order, 0, units, 0, array_length(units));
	array_sort(unit_render_order, function(_1, _2)
	{
		return _1.y - _2.y;
	});
}

refresh_render_order()

function battle_state_select_action()
{
	if (!instance_exists(obj_menu))
	{
	// get current unit
		var _unit = unit_turn_order[turn];
	
		// is unit dead?
		if (!instance_exists(_unit) || (_unit.hp <= 0))
		{
			battle_state = battle_state_victory_check;
			exit;
		}
	
		// select an action to perform
		// begin_action(_unit.id, global.action_library.attack, _unit.id);
	
		// if unit is player controlled:
		if (_unit.object_index == obj_battle_unit_PC)
		{
			var _menu_options = [];
			var _sub_menus = {};
		
			var _action_list = _unit.actions;
		
			for (var i = 0; i < array_length(_action_list); i++)
			{
				var _action = _action_list[i];
				var _available = true;
				var _name_and_count = _action.name; // later this will include the item count, if the action is an item
				if (_action.sub_menu == -1)
				{
					array_push(_menu_options, [_name_and_count, menu_select_action, [_unit, _action], _available]);
				}
				else
				{
					// create or add submenu
					if (is_undefined(_sub_menus[$ _action.sub_menu]))
					{
						variable_struct_set(_sub_menus, _action.sub_menu, [[_name_and_count, menu_select_action, [_unit, _action], _available]])
					}
					else
					{
						array_push(_sub_menus[$ _action.sub_menu], [_name_and_count, menu_select_action, [_unit, _action], _available]);
					
					}
				}
			}
			var _sub_menus_array = variable_struct_get_names(_sub_menus);
			for (var i = 0; i < array_length(_sub_menus_array); i++)
			{
				// sort submenu if needed
				// (here)
			
				// add back option at the end of each submenu
				array_push(_sub_menus[$ _sub_menus_array[i]], ["Back", menu_go_back, -1, true]);
				// add submenu to main menu
				array_push(_menu_options, [_sub_menus_array[i], sub_menu, [_sub_menus[$ _sub_menus_array[i]]], true]);
			}
		
			menu(x + 10, y + 110, _menu_options, , 74, 60);
		}
		else
		{
			//if unit is ai controlled
			var _enemy_action = _unit.ai_script();
			if (_enemy_action != -1) begin_action(_unit.id, _enemy_action[0], _enemy_action[1]);
		}
	}
}

function begin_action(_user, _action, _targets)
{
	current_user = _user;
	current_action = _action;
	current_targets = _targets;
	if (!is_array(current_targets)) current_targets = [current_targets]
	battle_wait_time_remaining = battle_wait_time_frames;
	with (_user)
	{
		acting = true;
		// play user animation
		if (!is_undefined(_action[$ "user_animation"])) && (!is_undefined(_user.sprites[$ _action.user_animation]))
		{
			sprite_index = sprites[$ _action.user_animation];
			image_index = 0;
		}
	}
	battle_state = battle_state_preform_action;
}

function battle_state_preform_action()
{
	if (current_user.acting) 
	{
		if (current_user.image_index >= current_user.image_number - 1)
		{
			with (current_user)
			{
				sprite_index = sprites.idle;
				image_index = 0;
				acting = false;
			}
			
			if (variable_struct_exists(current_action, "effect_sprite"))
			{
				current_action.func(current_user, current_targets);
				if (variable_struct_exists(current_action, "failed"))
				{
					if (current_action.failed == false)
					{
						if (current_action.effect_on_target == MODE.ALWAYS) || ( (current_action.effect_on_target == MODE.VARIES) && (array_length(current_targets) <= 1) )
						{
							for (var i = 0; i < array_length(current_targets); i++)
							{
								instance_create_depth(current_targets[i].x, current_targets[i].y, current_targets[i].depth - 1, obj_battle_effect, {sprite_index : current_action.effect_sprite});
							}
						}
						else
						{
							var _effect_sprite = current_action._effect_sprite
							if (variable_struct_exists(current_action, "effect_sprite_no_target")) _effect_sprite = current_action.effect_sprite_no_target;
							instance_create_depth(x, y, depth-100, obj_battle_effect, {sprite_index : _effect_sprite});
						}
						battle_state = battle_state_finish_action;
					}
					else
					{
						battle_state = battle_state_select_action;
					}
				}
				else
				{
					battle_state = battle_state_finish_action;
				}
			}
		}
	}
}

function battle_state_finish_action()
{
	if (!instance_exists(obj_battle_effect))
	{
		battle_wait_time_remaining--;
		if (battle_wait_time_remaining <= 0)
		{
			battle_state = battle_state_victory_check;
		}
	}
}

function battle_state_victory_check()
{
	refresh_party_health_order = function()
	{
		party_units_by_hp = [];
		array_copy(party_units_by_hp, 0, party_units, 0, array_length(party_units));
		array_sort(party_units_by_hp, function(_1, _2)
		{
			return _2.hp - _1.hp;
		});
	}
	refresh_party_health_order();
	
	refresh_enemy_health_order = function()
	{
		enemy_units_by_hp = [];
		array_copy(enemy_units_by_hp, 0,enemy_units, 0, array_length(enemy_units));
		array_sort(enemy_units_by_hp, function(_1, _2)
		{
			return _2.hp - _1.hp;
		});
	}
	refresh_enemy_health_order();
	
	if (party_units_by_hp[0].hp <= 0)
	{
		room_goto(rm_testing) // temperary
	}
	
	if (enemy_units_by_hp[0].hp <= 0)
	{
		for (var i = 0; i < array_length(global.party); i++)
		{
			global.party[i].hp = party_units[i].hp;
			global.party[i].mp = party_units[i].mp;
		}
		instance_activate_all();
		audio_stop_sound(snd_battle_start);
		audio_resume_sound(snd_town_theme);
		instance_destroy(creator);
		instance_destroy();	
	}
	
	battle_state = battle_state_turn_progression;
}

function battle_state_turn_progression()
{
	turn_count++;
	turn++;
	if (turn > array_length(unit_turn_order) - 1)
	{
		turn = 0;
		round_count++;
	}
	battle_state = battle_state_select_action;
}

battle_state = battle_state_select_action;




