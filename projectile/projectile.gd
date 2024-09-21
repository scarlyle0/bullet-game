extends Area2D

var speed = 1000  # Speed of the bullet

func _ready():
	pass

func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	# Move the bullet in the given direction
	position += direction * speed * delta
	
func destroy():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
