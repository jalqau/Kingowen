class_name LaserGun
extends FireArm

@export var fire_time: float = 0.3
var is_firing: bool = false

func attack() -> void:
	if is_firing:
		return
	is_firing = true
	

	ray.force_raycast_update()
	if ray.is_colliding():
		var target = ray.get_collider()
		if target is HitboxComponent:
			var hit_data := Attack.new()
			hit_data.attack_damage = attack_damage
			hit_data.knockback_force = knockback_force
			hit_data.attack_position = global_position
			hit_data.stun_time = stun_time
			target.damage(hit_data)

	await get_tree().create_timer(fire_time).timeout
	is_firing = false
