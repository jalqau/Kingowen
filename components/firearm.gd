class_name FireArm
extends Weapon

@export var bullet_scene: PackedScene
@onready var muzzle: Marker2D = $Muzzle

func attack() -> void:
	print('fire')
	var bullet = bullet_scene.instantiate()
	bullet.pos = muzzle.global_position
	bullet.rota = global_rotation
	bullet.dir = global_rotation
	bullet.attack_damage = attack_damage
	bullet.knockback_force = knockback_force
	bullet.stun_time = stun_time
	get_tree().current_scene.add_child(bullet)
