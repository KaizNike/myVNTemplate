extends CanvasLayer

const direction = {'up': Vector2.UP, 'down': Vector2.DOWN, 'left': Vector2.LEFT, 'right': Vector2.RIGHT}

# Because uid is supposed to be unique, we can simply overwrite when character
# joins the stage again... 

# What is the point of making this a singleton instead of a node
# inside a scene?

# 1. It separates characters from VNs, in case you want to use your 
# character sprites elsewhere, outside of VNs, e.g. you can call them
# in a custom movie scene via code. 
# 2. It makes each part of VN more independent, since
# characters are so important, they deserve their own stage.

# If character's fade_on_change is turned on, then there will be
# dummies named _dummy on stage. So exclude them in children.

func get_character_info(uid:String):
	if chara.all_chara.has(uid):
		return chara.all_chara[uid]
	else:
		vn.error("No character with this uid {0} is found".format({0:uid}))


func shake_chara(uid : String, amount: float, time: float):
	if uid == 'all':
		for n in get_children():
			if n.name != "_dummy" and n.in_all:
				n.shake(amount, time)
	else:
		var c = find_chara_on_stage(uid)
		c.shake(amount, time)


func jump(uid : String, dir:Vector2, amount: float, time : float):
	dir = dir.normalized()
	if uid == 'all':
		for n in get_children():
			if n.name != "_dummy" and n.in_all:
				n.jump(dir, amount, time)
	else:
		var c = find_chara_on_stage(uid)
		c.jump(dir, amount, time)

func change_pos(uid:String, loca:Vector2): # instant position change.
	var c = find_chara_on_stage(uid)
	c.position = loca
	c.loc = loca

func change_pos_2(uid:String, loca:Vector2, time:float, mode):
	var c = find_chara_on_stage(uid)
	c.change_pos_2(loca, time, mode)
	
func change_expression(uid:String, expression:String):
	var info = chara.all_chara[uid]
	if info.has('path'):
		var c = find_chara_on_stage(uid)
		c.change_expression(expression)

func fadein(uid: String, time: float, loc: Vector2, expression:String) -> void:
	# Ignore accidental spriteless character fadein
	var info = chara.all_chara[uid]
	if info.has('path'):
		if vn.skipping:
			join(uid,loc,expression)
		else:
			var ch_scene = load(info['path'])
			# If load fails, there will be a bug pointing to this line
			var c = ch_scene.instance()
			c.modulate = Color(0.86,0.86,0.86,0)
			add_child(c)
			c.position = loc
			c.fadein(time)
			c.change_expression(expression)
	

func fadeout(uid: String, time: float) -> void:
	if uid == 'all':
		for n in get_children():
			if n.name != "_dummy" and n.in_all:
				n.fadeout(time)
	else:
		var c = find_chara_on_stage(uid)
		c.fadeout(time)

func join(uid: String, loc: Vector2, expression:String) -> void:
	var info = chara.all_chara[uid]
	if info.has('path'):
		var ch_scene = load(info['path'])
		# If load fails, there will be a bug pointing to this line
		var c = ch_scene.instance()
		add_child(c)
		if c.change_expression(expression):
			c.position = loc
			c.loc = loc
			c.modulate = vn.DIM


func set_highlight(uid : String) -> void:
	# I didn't use find_chara_on_stage only for this function because
	# it might be the case that the speaking character hasn't joined
	# the stage yet. In that case, find character will give me null
	# and print the error message. I do not want that to happen because
	# this might happen pretty often.
	var info = chara.all_chara[uid]
	if info.has('path'):
		for n in get_children():
			if n.name != "_dummy" and n.unique_id == uid:
				n.modulate = Color(1,1,1,1)
				break

func remove_highlight() -> void:
	for n in get_children():
		if n.name != "_dummy" and n.apply_highlight:
			n.modulate = vn.DIM

func remove_chara(uid : String):
	if uid == 'absolute_all':
		for n in get_children():
			n.call_deferred("free")
			
	elif uid == 'all':
		for n in get_children():
			if n.name != "_dummy" and n.in_all:
				n.call_deferred("free")
	else:
		var c = find_chara_on_stage(uid)
		c.call_deferred("free")


# The methods below are only used internally, so no need to consider in_all
func set_modulate_4_all(c : Color):
	for n in get_children():
		n.modulate = c

func find_chara_on_stage(uid:String):
	for n in get_children():
		if n.name != "_dummy" and n.unique_id == uid:
			return n
			
	print('Warning: the character with uid {0} cannot be found or has not joined the stage.'.format({0:uid}))
	print("Depending on your event, you will get a bug or nothing will be done.")


func is_on_stage(uid : String) -> bool:
	for n in get_children():
		if n.name != "_dummy" and n.unique_id == uid:
			return true
			
	return false

func all_on_stage():
	var output = []
	for n in get_children():
		if n.name != "_dummy":
			var temp = {n.unique_id: n.current_expression, 'loc': n.position}
			output.append(temp)
			
	return output
