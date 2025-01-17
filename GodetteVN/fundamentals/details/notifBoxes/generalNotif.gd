extends TextureRect
class_name notificaionBox


var type : String

var following = false
var dragging_start_pos = Vector2()

# Used if type = override, override_dcision
signal decision(yes)

# Used every time, convenience signal when yielding for notification
signal clicked

func _on_back2MainBox_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_pos = get_local_mouse_position()

func _process(_delta):
	if following:
		self.rect_position = (get_global_mouse_position() - dragging_start_pos)

func set_text(which:String):
	self.type = which
	var tbox = self.get_node("notifText")
	match type:
		"quit":
			tbox.bbcode_text = "Do you want to quit the game?"
		"main":
			tbox.bbcode_text = "Do you want to go back to main menu?"
		"override":
			tbox.bbcode_text = "Do you want to override this file?"
		"rollback":
			tbox.bbcode_text = "You cannot rollback anymore."
			get_node("okButton").visible = true
			get_node("noButton").visible = false
			get_node("yesButton").visible = false
		"make_save":
			tbox.bbcode_text = "Do you want to make a save?"
		_:
			notif.hide()

func _on_noButton_pressed():
	emit_signal("clicked")
	notif.hide()

func _on_yesButton_pressed():
	match type:
		"main":
			fileRelated.write_to_config()
			screenEffects.removeLasting()
			screenEffects.weather_off()
			music.stop_bgm()
			stage.reset_sideImage()
			stage.remove_chara('absolute_all')
			#----------------------------------------
			var error = get_tree().change_scene(vn.ROOT_DIR + vn.main_menu_path)
			if error == OK:
				vn.reset_states()
		"override":
			emit_signal("decision", true)
		"quit":
			fileRelated.write_to_config()
			get_tree().quit()
		"make_save":
			fun.make_a_save("", 0.2)
	
	emit_signal("clicked")
	notif.hide()

func _on_okButton_pressed():
	emit_signal("clicked")
	notif.hide()
