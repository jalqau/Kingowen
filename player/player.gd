extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent

@export var speed: float = 300.0

var weapons: Array[Weapon] = []
var current_weapon: Weapon

@onready var aim_pivot: Node2D = $aim_pivot
@onready var animated_sprite_2d: AnimatedSprite2D = $aim_pivot/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

var is_attacking: bool = false

var hit1 = "hit"
var hit2 = "hit2"
var temp: String

# Анимация покоя для текущего оружия
var idle_animation: String = "default"

enum PlayerState {
	IDLE,
	RUN,
	ATTACK_HAND,
	SHOOT
}

var state: PlayerState = PlayerState.IDLE


func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

	for child in aim_pivot.get_children():
		if child is Weapon:
			weapons.append(child)
	equip(0)
	health_component.died.connect(_on_player_died)


func _on_animation_finished() -> void:
	is_attacking = false
	state = PlayerState.IDLE


func _physics_process(_delta: float) -> void:
	move()
	handle_weapon_switch()
	process_animation()
	handle_attack_input()


func process_animation() -> void:
	match state:
		PlayerState.IDLE:
			if animated_sprite_2d.animation != idle_animation:
				animated_sprite_2d.play(idle_animation)

		PlayerState.RUN:
			if animated_sprite_2d.animation != "run":
				animated_sprite_2d.play("run")

		PlayerState.ATTACK_HAND:
			if animated_sprite_2d.animation != hit1:
				animated_sprite_2d.play(hit1)

		PlayerState.SHOOT:
			if animated_sprite_2d.animation != "shoot":
				animated_sprite_2d.play("shoot")


func equip(index: int) -> void:
	if index >= weapons.size() or is_attacking:
		return

	for i in weapons.size():
		weapons[i].visible = (i == index)

	current_weapon = weapons[index]

	if index == 0:
		idle_animation = "default"
	elif index == 1:
		idle_animation = "default2"



func handle_weapon_switch() -> void:
	if Input.is_action_just_pressed("weapon_1"):
		equip(0)

	if Input.is_action_just_pressed("weapon_2"):
		equip(1)


func move() -> void:
	# Поворот к мышке
	var mouse_pos = get_global_mouse_position()
	aim_pivot.look_at(mouse_pos)

	# Движение игрока
	var input_direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if input_direction != Vector2.ZERO:
		if not is_attacking:
			state = PlayerState.RUN

		animated_sprite_2d_2.visible = true
		animated_sprite_2d_2.play("run")
		animated_sprite_2d_2.rotation = input_direction.angle() + PI / 2

	else:
		if not is_attacking:
			state = PlayerState.IDLE

		animated_sprite_2d_2.visible = false
		animated_sprite_2d_2.stop()

	velocity = input_direction * speed
	move_and_slide()


func handle_attack_input() -> void:
	var attack_br = Input.is_action_just_pressed("attack")

	if attack_br and not is_attacking:
		if current_weapon is FireArm:
			state = PlayerState.SHOOT
		else:
			state = PlayerState.ATTACK_HAND

		current_weapon.attack()
		is_attacking = true

func _on_player_died():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
