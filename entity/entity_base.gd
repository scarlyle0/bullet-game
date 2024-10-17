extends CharacterBody2D

signal hp_changed(new_hp)
signal hp_max_changed(new_hp_max)
signal died

const INDICATOR_DAMAGE = preload("res://UI/damage_indicator.tscn")

@export var hp_max: int = 100:
	set(value):
		if value != hp_max:
			hp_max = max(0, value)
			emit_signal("hp_max_changed", hp_max)
			healthBar.max_value = hp_max
			self.hp = hp

@export var hp: int = hp_max:
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			emit_signal("hp_changed", hp)
			healthBar.value = hp
			if hp == 0:
				emit_signal("died")
			elif hp != hp_max:
				healthBar.show()
	get:
		return hp
		
@export var defense: int = 0

@export var SPEED: int = 75

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var hurtbox = $hurtbox
@onready var healthBar = $EntityHealthBar

@export var EFFECT_HIT: PackedScene = null
@export var EFFECT_DIED: PackedScene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move()

func move():
	move_and_slide()

func death():
	spawn_effect(EFFECT_DIED)
	queue_free()

func recieve_damage(base_damage: int):
	var full_damage = base_damage
	full_damage -= defense
	
	self.hp -= full_damage
	return full_damage
	
func _on_hurtbox_area_entered(hitbox):
	var full_damage = recieve_damage(hitbox.damage)
	if hitbox.is_in_group("projectile"):
		hitbox.destroy()
		
	spawn_effect(EFFECT_HIT)
	spawn_damage_indicator(full_damage)


func _on_died():
	death()

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect
		
func spawn_damage_indicator(damage: int):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)
