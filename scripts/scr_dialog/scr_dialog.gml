function create_dialog(_messages)
{
	if (instance_exists(obj_dialog)) return;
	
	var _inst = instance_create_depth(0, 0, 0, obj_dialog);
	_inst.messages = _messages;
	_inst.current_message = 0;
}

char_colors = {
	"Congarts": c_yellow,
	"Me": c_yellow,
	"Oh No!": c_red
}

death_dialog = [
{
	name: "Oh No!",
	msg: "You died!"
},

{
	name: "Oh No!",
	msg: "You're hurt badly and some of your belongings have been taken"
},
]

bookshelf_dialog = [
{
	name: "Me",
	msg: "This is my bookshelf"
},

{
	name: "Me",
	msg: "it hasn't been touched in years"
}
]

bed1_dialog  = [
{
	name: "Me",
	msg: "This is my bed"
},

{
	name: "Me",
	msg: "I feel like i won't touch it in a while"
},

{
	name: "Me",
	msg: "Adventure is on the way!"
}
]