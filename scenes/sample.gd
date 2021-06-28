extends generalDialog


#---------------------------------- Choices ---------------------------------------
var food_choice = []


#---------------------------------- Core Dialog ---------------------------------------
var main_block = [
	{'bg': 'busstop.jpg'},
	{'dvar': 'money = 50'},
	{'chara': 'female join', 'loc': "1600 600", 'expression':''},
	{'female': 'Hello there. Let me introduce you to the system.'},
	{'female': 'It is a long long long long long long long sentence.'},
	{'female': 'Let it rain.'},
	{'weather': 'rain'},
	{'chara' : 'test2 fadein', 'time':2, 'loc': '300 600', 'expression':''},
	{'test2' : "Hey."},
	{'female': 'Let us try out the NVL mode.'},
	{'nvl': 'true'},
	{'female': "I just said something."},
	{'female': "More more more more."},
	{'': 'This is the narrator speaking.'},
	{'': 'More more more more.'},
	{'': 'I know you have [money] much money.'},
	{'nvl': 'false'},
	{'female': 'Ok, enough of that nvl nonsense.'},
	{'center': 'Hello?'},
	{'female': 'This is how you show centered text.'},
	{'history': 'push', '': 'THIS IS SUPPOSED TO BE SECRET!'},
	{'female': 'This is how you add secret text to history.'},
	{'history': 'pop'},
	{'female': "This is how you remove the last entry in history."},
	{'bgm':'myuu-angels.mp3'},
	{'female': 'This is how you play music.'},
	{'female': "This is how you switch to another Godot scene."},
	{'GDscene' : '/scenes/sampleScene2.tscn'}
	
]


#---------------------------------------------------------------------
# If you change the key word 'starter', you will have to go to generalDialog.gd
# and find start_scene, under if == 'new_game', change to blocks['starter'].
# Other key word you can change at will as long as you're refering to them correctly.
var conversation_blocks = {'starter' : main_block}

var choice_blocks = {}


#---------------------------------------------------------------------
func _ready():
	game.currentNodePath = get_tree().current_scene.filename
	get_tree().set_auto_accept_quit(false)
	start_scene(conversation_blocks, choice_blocks, game.load_instruction)
	
