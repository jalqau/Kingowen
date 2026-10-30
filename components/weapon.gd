class_name Weapon
extends Node2D

@export var attack_damage : float = 0.0
@export var knockback_force : float = 0.0
@export var stun_time : float = 0.0

func attack() -> void:
	print('attack')
	pass

func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var hit_data = Attack.new()
		hit_data.attack_damage = attack_damage
		hit_data.knockback_force = knockback_force
		hit_data.attack_position = global_position
		hit_data.stun_time = stun_time
		
		
		area.damage(hit_data)
