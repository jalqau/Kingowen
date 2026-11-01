extends Node2D
class_name HealthComponent

signal died

@export var MAX_HEALTH := 100.0
@onready var sound: AudioStreamPlayer2D = $Sound
var health : float
var is_dead := false

func _ready() -> void:
	health = MAX_HEALTH
 
func damage(attack: Attack):
	if is_dead:
		return
	health -= attack.attack_damage
	sound.play()
	
	if health <= 0 :
		is_dead = true
		died.emit()
