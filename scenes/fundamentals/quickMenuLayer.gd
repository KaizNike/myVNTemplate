extends Node2D

var settingsScene = preload("res://scenes/fundamentals/settings.tscn")
var historyScene = preload("res://scenes/fundamentals/historyScreen.tscn")
var saveScene = preload("res://scenes/fundamentals/saveScreen.tscn")
var loadScene = preload("res://scenes/fundamentals/loadScreen.tscn")
var quickSave = preload("res://scenes/fundamentals/details/saveSlot.tscn")

var hiding = false


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		notif.clear()
		notif.show("quit")
		reset_auto()
		reset_skip()

func _on_SettingButton_pressed():
	reset_auto()
	reset_skip()
	get_parent().add_child(settingsScene.instance())


func _on_SaveButton_mouse_entered():
	vn.noMouse = true
	

func _on_SaveButton_mouse_exited():
	vn.noMouse = false


func _on_SettingButton_mouse_entered():
	vn.noMouse = true


func _on_SettingButton_mouse_exited():
	vn.noMouse = false


func _on_quitButton_mouse_entered():
	vn.noMouse = true


func _on_quitButton_mouse_exited():
	vn.noMouse = false


func _on_historyButton_mouse_entered():
	vn.noMouse = true

func _on_historyButton_mouse_exited():
	vn.noMouse = false

func _on_mainButton_mouse_entered():
	vn.noMouse = true

func _on_mainButton_mouse_exited():
	vn.noMouse = false

func _on_historyButton_pressed():
	reset_auto()
	reset_skip()
	get_parent().add_child(historyScene.instance())


func _on_SaveButton_pressed():
	reset_auto()
	reset_skip()
	_create_screenshot()
	get_parent().add_child(saveScene.instance())


func _on_quitButton_pressed():
	notif.clear()
	notif.show("quit")
	reset_auto()
	reset_skip()
	
func _on_mainButton_pressed():
	notif.clear()
	notif.show("main")
	reset_auto()
	reset_skip()


func _on_autoButton_pressed():
	reset_skip()
	var auto = get_node('autoButton')
	vn.auto_on = not vn.auto_on
	if vn.auto_on:
		auto.modulate = Color(1,0,0,1)
	else:
		auto.modulate = Color(1,1,1,1)
		

func _on_autoButton_mouse_entered():
	vn.noMouse = true


func _on_autoButton_mouse_exited():
	vn.noMouse = false


func reset_auto():
	var auto = get_node('autoButton')
	auto.modulate = Color(1,1,1,1)
	vn.auto_on = false


func _on_skipButton_mouse_entered():
	vn.noMouse = true

func _on_skipButton_mouse_exited():
	vn.noMouse = false

func _on_skipButton_pressed():
	reset_auto()
	var sk = get_node('skipButton')
	vn.skipping = not vn.skipping
	if vn.skipping:
		sk.modulate = Color(1,0,0,1)
	else:
		sk.modulate = Color(1,1,1,1)

func reset_skip():
	var sk = get_node('skipButton')
	sk.modulate = Color(1,1,1,1)
	vn.skipping = false

func _on_loadButton_mouse_entered():
	vn.noMouse = true

func _on_loadButton_mouse_exited():
	vn.noMouse = false

func _on_loadButton_pressed():
	reset_auto()
	reset_skip()
	get_parent().add_child(loadScene.instance())


func disable_skip_auto():
	reset_auto()
	reset_skip()
	get_node("autoButton").disabled = true
	get_node("skipButton").disabled = true
	
func enable_skip_auto():
	get_node("autoButton").disabled = false
	get_node("skipButton").disabled = false


func _on_QsaveButton_mouse_entered():
	vn.noMouse = true

func _on_QsaveButton_mouse_exited():
	vn.noMouse = false

func _on_QsaveButton_pressed():
	_create_screenshot()
	var sl = quickSave.instance()
	var temp = game.currentSaveDesc
	game.currentSaveDesc = "[Quick Save]" + temp
	sl.make_save(sl.path)
	sl.queue_free()
	game.currentSaveDesc = temp




func _create_screenshot():
	var thumbnail = get_viewport().get_texture().get_data()
	thumbnail.flip_y()
	thumbnail.resize(vn.THUMBNAIL_WIDTH, vn.THUMBNAIL_HEIGHT, Image.INTERPOLATE_LANCZOS)
	game.currentFormat = thumbnail.get_format()
	
	var dir = Directory.new()
	if !dir.dir_exists(vn.THUMBNAIL_DIR):
		dir.make_dir_recursive(vn.THUMBNAIL_DIR)
		
	var file = File.new()
	var save_path = vn.THUMBNAIL_DIR + 'thumbnail.dat'
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		# store raw image data
		file.store_var(thumbnail.get_data())
		file.close()
