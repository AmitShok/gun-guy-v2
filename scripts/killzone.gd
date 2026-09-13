extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	_body.modulate = Color(10, 1, 1)
	print("you died!")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
