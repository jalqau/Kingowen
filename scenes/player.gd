extends CharacterBody2D
@export var speed: float = 300.0
@onready var melee_weapon: MeleeWeapon = $Sword

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move()
	handle_attack_input()

@onready var aim_pivot: Node2D = $aim_pivot


@onready var animated_sprite_2d: AnimatedSprite2D = $aim_pivot/AnimatedSprite2D

@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2


func move():
	
	#mouse
	var mouse_pos = get_global_mouse_position()
	aim_pivot.look_at(mouse_pos)
	
	#player move
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	
	if input_direction != Vector2.ZERO:
		#анимация бега тела
		animated_sprite_2d.play("run")
		#анимация бега ног
		animated_sprite_2d_2.visible = true
		animated_sprite_2d_2.play("run")
		animated_sprite_2d_2.rotation = input_direction.angle() + PI / 2
	else:
		#анимация при остнавки чтобы он просто стоял смирно когда не двигается
		animated_sprite_2d.play("default")
		#тоже самое просто ноги еще и исчезают
		animated_sprite_2d_2.visible = false
		animated_sprite_2d_2.stop()
	
	velocity = input_direction * speed
	move_and_slide()
func handle_attack_input():
	var attack_br = Input.is_action_just_pressed("attack")
	
	if attack_br :
		melee_weapon.attack()
	
func boredom():
	pass
