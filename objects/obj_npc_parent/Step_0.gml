if (instance_exists(obj_dialog)) exit;

if (instance_exists(obj_player) && distance_to_object(obj_player) < 8)
{
	can_talk = true;
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")))
	{
		create_dialog(dialog);
	}
}
else
{
	can_talk = false;
}