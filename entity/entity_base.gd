extends CharacterBody2D

signal hp_changed(new_hp)
signal hp_max_changed(new_hp_max)
signal died

@export var hp_max: int = 100:
	set(value):
		if value != hp_max:
			hp_max = max(0, value)
			emit_signal("hp_max_changed", hp_max)
			self.hp = hp

@export var hp: int = hp_max:
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			emit_signal("hp_changed", hp)
			if hp == 0:
				emit_signal("died")
	get:
		return hp
		
@export var defense: int = 0

@export var SPEED: int = 75

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var hurtbox = $hurtbox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move()

func move():
	move_and_slide()

func death():
	queue_free()

func recieve_damage(base_damage: int):
	var full_damage = base_damage
	full_damage -= defense
	
	self.hp -= full_damage
	print(name + " recieved " + str(full_damage) + " damage")
	
func _on_hurtbox_area_entered(hitbox):
	recieve_damage(hitbox.damage)


func _on_died():
	death()
