extends CharacterBody2D

# Movement Constants
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const BOUNCE_VELOCITY = -300.0 

# Dash Constants
const DASH_SPEED = 400.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

# State Variables
var jump_count = 0
var is_dashing = false
var can_dash = true
var is_invincible = false # Prevents dying while stomping

@export var extrajump = 1
@onready var animated_sprite = $AnimatedSprite2D

# REQUIRED: Area2D child named "StompDetector"
@onready var stomp_detector = $StompDetector 

func _physics_process(delta: float) -> void:
	
	# 1. Handle Gravity and Jump Resets
	if is_on_floor():
		jump_count = 0
	elif not is_dashing:
		velocity += get_gravity() * delta
		if jump_count == 0:
			jump_count = 1

	# 2. Handle Jump & Double Jump
	if Input.is_action_just_pressed("ui_up"):
		if jump_count <= extrajump:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	
	# 3. Handle Dash Input
	if Input.is_action_just_pressed("ui_accept") and can_dash:
		start_dash()

	# 4. Get Input Direction
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# 5. Movement & Animation Logic
	if is_dashing:
		var dash_dir = -1 if animated_sprite.flip_h else 1
		velocity.x = dash_dir * DASH_SPEED
		velocity.y = 0 
	elif direction:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")
	
	move_and_slide()
	
	# 6. Check for Stomps
	_check_for_stomp()

func _check_for_stomp():
	# Only detect stomps if falling downwards
	if velocity.y > 0:
		# Since your enemy is a Node2D/Area2D combo, we check Areas
		var targets = stomp_detector.get_overlapping_areas()
		
		for area in targets:
			if area.is_in_group("enemies") or area.get_parent().is_in_group("enemies"):
				# Ensure player is actually above the enemy's vertical center
				if global_position.y < area.global_position.y:
					execute_stomp(area)

func execute_stomp(area):
	# 1. Grant temporary invincibility so the enemy's hitbox doesn't kill us
	is_invincible = true
	
	# 2. Bounce the player
	velocity.y = BOUNCE_VELOCITY
	jump_count = 1 
	
	# 3. Kill the enemy (check area first, then parent)
	var enemy = area.get_parent()
	if enemy.has_method("take_damage"):
		enemy.take_damage(100)
	elif area.has_method("take_damage"):
		area.take_damage(100)
	else:
		enemy.queue_free()
	
	# 4. End invincibility after a tiny delay
	await get_tree().create_timer(0.1).timeout
	is_invincible = false

# Call this function when the player gets hit by an enemy
func take_damage():
	if is_invincible:
		return # Do nothing, we are currently stomping!
	
	# Your existing death logic here (e.g., reload scene)
	get_tree().reload_current_scene()

func start_dash():
	is_dashing = true
	can_dash = false
	animated_sprite.modulate.a = 0.5
	
	await get_tree().create_timer(DASH_DURATION).timeout
	is_dashing = false
	animated_sprite.modulate.a = 1.0
	
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
