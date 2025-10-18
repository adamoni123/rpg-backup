function new_encounter(_enemies, )
{
	instance_create_depth
	(
		camera_get_view_x(view_camera[0]),
		camera_get_view_y(view_camera[0]),
		-9999,
		obj_battle,
		{ enemies: _enemies, creator: id}
	);
}

function battle_change_hp(_target, _amount, _alive_dead_or_either)
{
	// _alive_dead_or_either: 0 = alive only, 1 = dead only, 2 = any
	var _failed = false;
	if (_alive_dead_or_either == 0) && (_target.hp <= 0) _failed = true;
	if (_alive_dead_or_either == 1) && (_target.hp > 0) _failed = true;
	
	var _col = c_white;
	if (_amount > 0) _col = c_lime;
	if (_failed)
	{
		_col = c_white;
		_amount = "failed";
	}
	instance_create_depth
	(
	_target.x,
	_target.y,
	_target.depth-1,
	obj_battle_floating_text,
	{font: fn_secondary, col: _col, text: string(_amount)}
	);
	if (!_failed) _target.hp = clamp(_target.hp + _amount, 0, _target.max_hp);
}

function battle_change_mp(_target, _amount)
{
	_target.mp = clamp(_target.mp + _amount, 0, _target.max_mp);
}