var _enemy_amount = irandom_range(1,3);

if (_enemy_amount == 1)
{
	new_encounter([global.enemies.slime]);
} 
else if (_enemy_amount == 2)
{
	new_encounter([global.enemies.slime, global.enemies.slime]);
}
else if (_enemy_amount == 3)
{
	new_encounter([global.enemies.slime, global.enemies.slime, global.enemies.slime]);
}