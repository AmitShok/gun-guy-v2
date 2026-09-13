extends CharacterBody2D
@onready var muzzle_right: Node2D = $MuzzleRight
@onready var muzzle_left: Node2D = $MuzzleLeft
@onready var bullet_ammo_display: HBoxContainer = %bulletAmmoDisplay

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const maxBulletCount = 5


@export var bullet_scene : PackedScene 
@onready var animated_sprite = $AnimatedSprite2D
@export var bullet_spawn_offset := Vector2(24, 0)
var facing := 1
var bulletCount = maxBulletCount
var ammoCount = 5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		animated_sprite.flip_h = true
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")
	
	move_and_slide()
	


# Drag and drop your Bullet.tscn from the FileSystem into this variable



func _input(event):
	if event.is_action_pressed("shoot") && bulletCount > 0: # Define "shoot" in Project Settings -> Input Map
		shoot()
		
		# takes player back to main menu when pressing escape 
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	if Input.is_action_just_pressed("reload"):
		_reload()

func shoot():
	var b = bullet_scene.instantiate()
	owner.add_child(b)
	if animated_sprite.flip_h == true:
		b.global_position = muzzle_left.global_position
		b.direction = -1
		b.rotation_degrees = 180
	else:
		#facing right
		b.global_position = muzzle_right.global_position
		b.rotation_degrees = 0
		b.direction = 1
	bulletCount -= 1
	bullet_ammo_display.refresh_bullets(bulletCount)



func _reload():
	var reloadCount = maxBulletCount - bulletCount
	
	if ammoCount >= reloadCount:
		bulletCount += reloadCount
		ammoCount -= reloadCount
	else:
		bulletCount += ammoCount
		ammoCount = 0
	bullet_ammo_display.refresh_bullets(bulletCount)
	bullet_ammo_display.refresh_ammo_count(ammoCount)
