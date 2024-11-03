extends Node

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

func death():
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

func _on_died():
	death()
