if (instance_exists(obj_dialog))
{
	image_index = 0;
	exit;
}


// get inputs
right_key = keyboard_check(vk_right);
left_key = keyboard_check(vk_left);
up_key = keyboard_check(vk_up);
down_key = keyboard_check(vk_down);


/* set the xspd and yspd variables to the
directions that are currently being pressed * the move_speed */
xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;


// pause
if instance_exists(obj_pauiser)
{
	xspd = 0;
	yspd = 0;
}


// set sprite and animations
mask_index = sprite[DOWN];
if yspd == 0 
	{
	if xspd > 0 {face = RIGHT};
	if xspd < 0 {face = LEFT};
	}
if xspd > 0 && face == LEFT {face = RIGHT};
if xspd < 0 && face == RIGHT {face = LEFT};

if xspd == 0 
	{
	if yspd > 0 {face = DOWN};
	if yspd < 0 {face = UP};
	}
if yspd > 0 && face == UP {face = DOWN};
if yspd < 0 && face == DOWN {face = UP};
sprite_index = sprite[face];


// collisions
if place_meeting( x + xspd, y, obj_wall ) == true
	{
	xspd = 0;
	}
if place_meeting( x, y + yspd, obj_wall ) == true
	{
	yspd = 0;
	}

// add the xspd and yspd to the current positions
x += xspd;
y += yspd;


if xspd == 0 && yspd == 0
{
	image_index = 0;
}

// why are you snooping around the game's code?