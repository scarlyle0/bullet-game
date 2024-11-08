extends Node2D
signal hp_changed(new_hp)
signal hp_max_changed(new_hp_max)
signal died

@onready var healthBar = $EntityHealthBar

@export var EFFECT_HIT: PackedScene = null
@export var EFFECT_DIED: PackedScene = null

const INDICATOR_DAMAGE = preload("res://UI/damage_indicator.tscn")

func _ready():
	var hurtbox = get_node("../Hurtbox")
	if hurtbox:
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)

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

func death():
	spawn_effect(EFFECT_DIED)
	get_parent().queue_free()


func recieve_damage(base_damage: int):
	var full_damage = base_damage
	full_damage -= defense
	
	self.hp -= full_damage
	print(self.hp)
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
