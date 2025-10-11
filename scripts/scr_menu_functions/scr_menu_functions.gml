/// @desc menu - makes a menu, options providedin the form [["name", function, argument, available], [...]]
function menu(_x, _y, _options, _description = -1, _width = undefined, _height = undefined)
{
	with (instance_create_depth(_x, _y, -99999, obj_menu))
	{
		options = _options;
		description = _description;
		var _options_count = array_length(_options);
		visible_options_max = _options_count;
		
		
		// set up size
		xmargin = 10;
		ymargin = 8;
		draw_set_font(fn_secondary);
		height_line = 12;
		
		// auto width
		if (_width == undefined)
		{
			_width = 1;
			if (description != -1) width = max(width, string_width(_description));
			for (var i = 0; i < _options_count; i++)
			{
				width = max(_width, string_width(_options[i][0]));
			}
			width_full = width + xmargin * 2;
		} else width_full = _width;
		
		// auto height
		if (_height == undefined)
		{
			height = height_line * (_options_count + (description != -1));
			height_full = height + ymargin * 2;
		}
		else
		{
			height_full = _height;
			// scrolling?
			if (height_line * (_options_count + (description != -1)) > _height - (ymargin * 2))
			{
				scrolling  = true;
				visible_options_max = (_height - ymargin * 2) div height_line;
			}
		}
	}
}

function sub_menu(_options)
{
	// store old options in array and increase submenu level
	options_above[sub_menu_level] = options;
	sub_menu_level++;
	options  = _options;
	hover = 0;
}

function menu_go_back()
{
	sub_menu_level--;
	options = options_above[sub_menu_level];
	hover = 0;
}

function menu_select_action(_user, _action)
{
	with (obj_menu) active = false;
	// activate targetting cursor if needed
	with (obj_battle) 
	{
		if (_action.target_required)
		{
			with (cursor)
			{
				active = true;
				active_action = _action;
				target_all = _action.target_all
				if (target_all == MODE.VARIES) target_all = true;
				active_user = _user;
				
				// which side?
				if (_action.target_enemy_by_default)
				{
					target_index = 0;
					target_side = obj_battle.enemy_units;
					active_target = obj_battle.enemy_units[target_index];
				}
				else
				{
					target_side = obj_battle.party_units;
					active_target = active_user;
					var _find_self = function(_element)
					{
						return (_element == active_target)
					}
					target_index = array_find_index(obj_battle.party_units, _find_self);
				}
			}
		}
		else
		{
			// if action does need a target, begin the action and close menu
			begin_action(_user, _action, -1);
			with (obj_menu) instance_destroy();
		}
	}
}











