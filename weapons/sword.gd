extends MeleeWeapon

@export var swing_time : float = 0.4
@export var hit_time : float = 0.15

var is_swinging : bool = false

@onready var attack_area : Area2D = $AttackArea

func attack() -> void:
	if is_swinging:
		return
	is_swinging = true

	attack_area.set_deferred("monitoring", true)
	await get_tree().create_timer(hit_time).timeout
	attack_area.set_deferred("monitoring", false)

	await get_tree().create_timer(swing_time - hit_time).timeout
	is_swinging = false

func _on_attack_area_area_entered(area: Area2D) -> void:
	_on_hitbox_component_area_entered(area)
