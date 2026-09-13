extends Area2D

@export var speed: float = 600.0
@export var damage: int = 100

# 1 for Right, -1 for Left
var direction: int = 1 

func _physics_process(delta: float) -> void:
	# Move the bullet forward
	position.x += speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Clean up memory when bullet leaves the screen
	queue_free()

# 1. DETECTS ENEMIES (Areas)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			area.take_damage(1)
		queue_free()

# 2. DETECTS WALLS/TILES (Physics Bodies)
func _on_body_entered(body: Node2D) -> void:
	# TileMaps are considered "bodies," not "areas."
	# This will trigger when hitting TileMaps, StaticBody2Ds, or CharacterBody2Ds
	if body is TileMap or body.is_in_group("level"):
		explode()
	elif body.name != "Player": # Optional: Prevents bullet from hitting the shooter
		explode()

func explode():
	# You can add particle effects or sounds here later!
	queue_free()
