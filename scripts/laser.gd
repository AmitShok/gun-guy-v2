extends Area2D


@export var damage = 100



func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1) # This calls the function on the Hurtbox
		
