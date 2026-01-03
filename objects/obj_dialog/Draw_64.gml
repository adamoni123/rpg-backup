var _spacing = 10;
var _padding = 25;
var _dx = 0 + _spacing;
var _dy = gui_h * 0.75;
var _boxw = gui_w - _spacing * 2;
var _boxh = gui_h - _dy - _spacing;
var _tsize = 3;

draw_sprite_stretched(spr_box_big, 0, _dx, _dy, _boxw, _boxh);

_dx += _padding;
_dy += _padding;

draw_set_font(fn_main_bold);


var _name = messages[current_message].name;
draw_set_colour(global.char_colors[$ _name]);
draw_text_transformed(_dx, _dy, _name, _tsize - 1, _tsize - 1, 0);
draw_set_colour(c_white);

_dy += 40;

draw_text_ext_transformed(_dx, _dy, draw_message, -1, _boxw -_dx * 2, _tsize, _tsize, 0)