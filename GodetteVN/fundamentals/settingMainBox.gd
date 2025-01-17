extends Control

func _ready():
	var voiceVolSlider = $voiceBox/voiceSettings/voiceSlider
	var effectVolSlider = $effectBox/effectSettings/effectVolumeSlider
	var musicVolSlider = $musicBox/musicSettings/volumeSlider
	var bgm_vol = fileRelated.system_data['bgm_volume']
	var eff_vol = fileRelated.system_data['eff_volume']
	var voice_vol = fileRelated.system_data['voice_volume']
	$musicBox/musicSettings/musicVolume.text = str(bgm_vol + 50)
	$effectBox/effectSettings/effectVolume.text = str(eff_vol + 50)
	$voiceBox/voiceSettings/voiceVolume.text = str(voice_vol + 50)
	musicVolSlider.value = bgm_vol
	effectVolSlider.value = eff_vol
	voiceVolSlider.value = voice_vol
	if bgm_vol <= musicVolSlider.min_value:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_volume_db(1, bgm_vol)
		
	if eff_vol <= effectVolSlider.min_value:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_volume_db(2, eff_vol)
	
	if voice_vol <= voiceVolSlider.min_value:
		AudioServer.set_bus_mute(3, true)
	else:
		AudioServer.set_bus_volume_db(2, voice_vol)
	
	var auto = get_node("autoBox/autoSpeed")
	auto.add_item('Slow')
	auto.add_item('Normal')
	auto.add_item('Fast')
	print(fileRelated.system_data['auto_speed'])
	auto.select(fileRelated.system_data['auto_speed'])
	
func _on_volumeSlider_value_changed(value):
	fileRelated.system_data['bgm_volume'] = value
	$musicBox/musicSettings/musicVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(1, value)
	if value <= $musicBox/musicSettings/volumeSlider.min_value:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_mute(1,false)
		
func _on_effectVolumeSlider_value_changed(value):
	fileRelated.system_data['eff_volume'] = value
	$effectBox/effectSettings/effectVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(2, value)
	if value <= $effectBox/effectSettings/effectVolumeSlider.min_value:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_mute(2,false)

func _on_voiceSlider_value_changed(value):
	fileRelated.system_data['voice_volume'] = value
	$voiceBox/voiceSettings/voiceVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(3, value)
	if value <= $voiceBox/voiceSettings/voiceSlider.min_value:
		AudioServer.set_bus_mute(3,true)
	else:
		AudioServer.set_bus_mute(3,false)

func _on_autoSpeed_item_selected(index):
	fileRelated.system_data['auto_speed'] = index
	vn.auto_bound = ((-1)*index + 3.25)*20
