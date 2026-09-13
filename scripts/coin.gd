extends Area2D

@export var ammo_amount := 5  # How much ammo the coin gives

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the gun player
	# We check for 'ammoCount' to make sure the variable exists on the body
	if "ammoCount" in body:
		body.ammoCount += ammo_amount
		
		# Update the UI so the player sees the new total immediately
		if body.bullet_ammo_display:
			body.bullet_ammo_display.refresh_ammo_count(body.ammoCount)
		
		print("+", ammo_amount, " ammo collected!")
		queue_free() # Remove the coin from the game
	
	#this is so the knight player removes the coin after pickup 
	queue_free()
