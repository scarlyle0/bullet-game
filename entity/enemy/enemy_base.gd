extends "res://entity/entity_base.gd"

@onready var player = get_node("../Player")


func _process(delta):
	if player:
		# Get the camera's rotation
		var player_rotation = player.rotation
		
		# Set the enemy sprite's rotation to match the camera's rotation
		rotation = player_rotation
