extends CharacterBody2D

@export var speed: float = 300.0

@onready var melee_weapon: Weapon = $aim_pivot/Sword
@onready var aim_pivot: Node2D = $aim_pivot
@onready var animated_sprite_2d: AnimatedSprite2D = $aim_pivot/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

var is_attacking: bool = false
var hit1 = "hit"
var hit2 = "hit2"
var temp: String

enum PlayerState {
	IDLE,
	RUN,
	ATTACK_HAND,
	SHOOT
}

var state: PlayerState = PlayerState.IDLE

func process_animation():
	match state:
		PlayerState.IDLE:
			if animated_sprite_2d.animation != "default":
				animated_sprite_2d.play("default")
				
		PlayerState.RUN:
			if animated_sprite_2d.animation != "run":
				animated_sprite_2d.play("run")
				
		PlayerState.ATTACK_HAND:
			if animated_sprite_2d.animation != hit1:
				animated_sprite_2d.play(hit1)

		PlayerState.SHOOT:
			if animated_sprite_2d.animation != "shoot":
				animated_sprite_2d.play("shoot")

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
	is_attacking = false


func _physics_process(delta: float) -> void:
	move()
	handle_attack_input()
	process_animation()


func move():

	#mouse
	var mouse_pos = get_global_mouse_position()
	aim_pivot.look_at(mouse_pos)

	#player move
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO:
		if not is_attacking:
			state = PlayerState.RUN
			

		#анимация бега ног
		animated_sprite_2d_2.visible = true
		animated_sprite_2d_2.play("run")
		animated_sprite_2d_2.rotation = input_direction.angle() + PI / 2

	else:
		#анимация при остановке
		if not is_attacking:
			state = PlayerState.IDLE

		#тоже самое, просто ноги еще и исчезают
		animated_sprite_2d_2.visible = false
		animated_sprite_2d_2.stop()

	velocity = input_direction * speed
	move_and_slide()


func handle_attack_input():
	var attack_br = Input.is_action_just_pressed("attack")

	if attack_br:
		state = PlayerState.ATTACK_HAND
		melee_weapon.attack()
		is_attacking = true
		


func boredom():
	pass
