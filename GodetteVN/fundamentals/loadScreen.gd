extends CanvasLayer

var slot = preload("res://GodetteVN/fundamentals/details/saveSlot.tscn")

func _ready():
	vn.inSetting = true
	
	# Create the appearance
	var saves = fileRelated.get_save_files()
	for i in range(saves.size()):
		var saveSlot = slot.instance()
		var file = File.new()
		var error = file.open_encrypted_with_pass(vn.SAVE_DIR + saves[i], File.READ, "nanithefuck")
		if error == OK:
			var data = file.get_var()
			saveSlot.mode = 1 # loading mode
			saveSlot.set_description(data['currentSaveDesc'])
			saveSlot.set_datetime(data['datetime'])
			saveSlot.path = vn.SAVE_DIR + saves[i]
			# thumbnail
			var thumbnail = saveSlot.get_node("Button/HBoxContainer/saveThumbnail")
			thumbnail.texture = fileRelated.data2Thumbnail(data['thumbnail'], data['format'])
			saveSlot.connect('load_ready', self, 'load_save')
			$ScrollContainer/allSaves.add_child(saveSlot)
			file.close()
	
func load_save():
	vn.reset_states() # inSetting = false
	stage.remove_chara('absolute_all')
	var error = get_tree().change_scene(game.currentNodePath)
	if error == OK:
		self.queue_free()
	
func _on_returnButton_pressed():
	vn.inSetting = false
	self.queue_free()

func _input(ev):
	if ev.is_action_pressed('ui_cancel') or ev.is_action_pressed('vn_cancel'):
		get_tree().set_input_as_handled()
		vn.inSetting = false
		self.queue_free()
