extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
@onready var sound: AudioStreamPlayer2D = $Sound
var health : float

func _ready() -> void:
	health = MAX_HEALTH
 
func damage(attack: Attack):
	health -= attack.attack_damage
	sound.play()
	
	if health <= 0 :
		get_parent().queue_free()
