if (keyboard_check_pressed(ord("P")) && !audio_is_playing(snd_town_theme))
{
	audio_play_sound(snd_town_theme, 0, true);
}