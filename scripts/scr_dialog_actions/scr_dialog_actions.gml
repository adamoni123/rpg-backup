#macro TEXT new text_action

function dialog_action() constructor
{
	act = function() { };
}

function text_action(_text) : dialog_action() constructor 
{
	text = _text;
	
	act = function(textbox)
	{
		textbox.set_text(text);
	}
}