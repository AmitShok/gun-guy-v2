extends Area2D

# This script lives on the Hurtbox node
func take_damage(amount):
	# get_parent() looks at the main Enemy node
	if get_parent().has_method("take_damage"):
		get_parent().take_damage(amount)
	else:
		# If the main enemy script has the health logic, call it here
		print("Hurtbox hit, but parent enemy script is missing take_damage!")
