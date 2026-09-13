extends Node

const SETTINGS_PATH := "user://settings.cfg"

var music_volume := 1.0


func _ready() -> void:
	_load_settings()
	call_deferred("_apply_music_volume")


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_save_settings()
	_apply_music_volume()


func _load_settings() -> void:
	var settings := ConfigFile.new()
	if settings.load(SETTINGS_PATH) == OK:
		music_volume = clampf(float(settings.get_value("audio", "music_volume", 1.0)), 0.0, 1.0)


func _save_settings() -> void:
	var settings := ConfigFile.new()
	settings.set_value("audio", "music_volume", music_volume)
	var error := settings.save(SETTINGS_PATH)
	if error != OK:
		push_error("Could not save audio settings. Error code: %s" % error)


func _apply_music_volume() -> void:
	var music_player := get_node_or_null("/root/BackgroundMusic") as AudioStreamPlayer2D
	if music_player:
		# Keep the player valid at zero volume rather than using negative infinity.
		music_player.volume_db = linear_to_db(max(music_volume, 0.001))
