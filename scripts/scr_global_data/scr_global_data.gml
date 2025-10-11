global.action_library =
{
	attack :
	{
		name: "attack",
		description: "{0} attacks!",
		sub_menu: -1,
		target_required: true,
		target_enemy_by_default: true,
		target_all: MODE.NEVER,
		effect_sprite: spr_hit_effect,
		effect_on_target: MODE.ALWAYS,
		func: function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil( ((_user.strength * 0.5) * _user.attack_power) + random_range(-_user.strength * 0.25, _user.strength * 0.25) - ((_targets[0].endurance + (_targets[0].agility * 0.5)) * 0.5));
				if (_damage <= 0) _damage = 0;
				battle_change_hp(_targets[0], -_damage, 0);
			}
		}
	},
	ice :
	{
		name: "Ice",
		description: "{0} casts Ice!",
		sub_menu: "Magic",
		mp_cost: 7,
		target_required: true,
		target_enemy_by_default: true,
		target_all: MODE.VARIES,
		effect_sprite: spr_hit_effect,
		effect_on_target: MODE.ALWAYS,
		func: function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil( ( (_user.intelligence * 1.5) + irandom_range(-_user.intelligence * 0.5, _user.intelligence * 1.5)) - irandom_range(_targets[0].endurance * 0.5, _targets[0].endurance) )
				if (array_length(_targets) > 1) _damage = ceil(irandom_range(_user.intelligence, _user.intelligence * 1.5))
				battle_change_hp(_targets[i], -_damage, 0)
			}
			battle_change_mp(_user, -mp_cost)
		}
	}
}


enum MODE
{
	NEVER = 0,
	ALWAYS = 1,
	VARIES = 2
}

global.party = 
[
		{
		name: "player",
		hp: 100,
		max_hp: 100,
		mp: 30,
		max_mp: 30,
		attack_power: 2,
		strength: 5,
		agility: 5,
		intelligence: 5,
		endurance: 5,
		actions: [global.action_library.attack, global.action_library.ice],
		sprites: { idle: spr_player_right, attack: spr_player_down, down: spr_player_down } // temp sprites
		}
];

global.enemies = 
{
	slime:
		{
		name: "slime",
		hp: 30,
		max_hp: 30,
		attack_power: 2,
		strength: 5,
		agility: 7,
		intelligence: 2,
		endurance: 3,
		xp_value: 15,
		actions: [global.action_library.attack],
		sprites: { idle: spr_slime, attack: spr_slime },
		ai_script: function()
		{
			// attack random party member
			var _action = actions[0];
			var _possible_targets = array_filter(obj_battle.party_units, function(_unit, _index)
			{
				return (_unit.hp > 0);
			});
			var _target = _possible_targets[irandom(array_length(_possible_targets) - 1)];
			return [_action, _target];
		}

	}
	
};