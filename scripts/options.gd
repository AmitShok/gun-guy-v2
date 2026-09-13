extends Node2D

@onready var volume_slider: HSlider = $Button_manager/VolumeSlider
@onready var volume_value: Label = $Button_manager/VolumeValue


func _ready() -> void:
	var game_settings := get_node_or_null("/root/GameSettings")
	if game_settings:
		volume_slider.value = float(game_settings.get("music_volume")) * 100.0
	else:
		var music_player := get_node_or_null("/root/BackgroundMusic") as AudioStreamPlayer2D
		if music_player:
			volume_slider.value = db_to_linear(music_player.volume_db) * 100.0
		else:
			volume_slider.value = 100.0
	_update_volume_label(volume_slider.value)


func _on_volume_slider_value_changed(value: float) -> void:
	var game_settings := get_node_or_null("/root/GameSettings")
	if game_settings and game_settings.has_method("set_music_volume"):
		game_settings.call("set_music_volume", value / 100.0)
	else:
		var music_player := get_node_or_null("/root/BackgroundMusic") as AudioStreamPlayer2D
		if music_player:
			music_player.volume_db = linear_to_db(max(value / 100.0, 0.001))
	_update_volume_label(value)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _update_volume_label(value: float) -> void:
	volume_value.text = "%d%%" % roundi(value)
