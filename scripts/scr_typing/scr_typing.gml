function start_dialog(topic) 
{
	if (instance_exists(obj_textbox)) return;
	
	var inst = instance_create_depth(x, y, -999, obj_textbox);
	inst.set_topic(topic);
}

function type(x, y, text, progress, width)
{
	var draw_x = 0;
	var draw_y = 0;
/*	
	if you're reading this, let me tell you  a story.
	my dad really wants me to finish this game, but i don't think i can.
	i think i'm too dumb, and i don't think i can do it.
	but if you're reading this, that means that i did make it, that i did finish it.
	and not only did i finish it, but that you liked it enough to go into the game's files to look for stuff
	so to you, dear player or modder (or pirate, i don't judge lol) thank you for enjoying my game.
	you're welcome to tell me that you found this easter egg via whatever method you can find to talk to me (probably bsky)
	<3 <3 <3
*/
	for (var i = 1; i <= progress; i++)
	{
		var char = string_char_at(text, i);
		
		if (char == "\n")
		{
			draw_x = 0;
			draw_y += string_height("A");
		}
		else if (char == " ")
		{
			draw_x += string_width(char);
			
			var word_width = 0;
			for (var ii = i + 1; ii <= string_length(text); ii++)
			{
				var word_char = string_char_at(text, ii);
				
				// If we reached the end of the word, stop checking
				if (word_char == "\n" || word_char == " ")
					break;
				
				// If the current word extends past the width boundary,
				// then move it to the next line
				word_width += string_width(word_char);
				if (draw_x + word_width > width)
				{
					draw_x = 0;
					draw_y += string_height("A");
					break;
				}
			}
		}
		else
		{
			draw_text(x + draw_x, y + draw_y, char);
			draw_x += string_width(char);
		}
	}
}