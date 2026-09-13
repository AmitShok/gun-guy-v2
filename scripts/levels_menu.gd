extends Node2D




func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_2.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
