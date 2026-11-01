class_name Bullet
extends CharacterBody2D

var pos:Vector2
var rota:float
var dir:float
@export var attack_damage: float = 0.0
@export var knockback_force: float = 0.0
@export var stun_time: float = 0.0
@export var speed: float = 2000.0




func _ready() -> void:
	global_position=pos
	global_rotation=rota

func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(dir) * speed
	move_and_slide()



func _on_hitbox_component_area_entered(area: Area2D) -> void:

	if area is HitboxComponent:

		var hitbox: HitboxComponent = area

		var hit_data := Attack.new()
		hit_data.attack_damage = attack_damage
		hit_data.knockback_force = knockback_force
		hit_data.attack_position = global_position
		hit_data.stun_time = stun_time

		hitbox.damage(hit_data)
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	

	if area is HitboxComponent:
		

		var hitbox: HitboxComponent = area

		var hit_data := Attack.new()
		hit_data.attack_damage = attack_damage
		hit_data.knockback_force = knockback_force
		hit_data.attack_position = global_position
		hit_data.stun_time = stun_time

		hitbox.damage(hit_data)
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Благодаря маске, сюда попадет только стена (или игрок, если вы выбрали оба слоя)
	queue_free()
