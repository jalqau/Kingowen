extends CharacterBody2D
@export var speed = 300.0


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move()


func move():
	
	#mouse
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	#player move
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_direction * speed
	move_and_slide()
func attack():
	
	pass
func health():
	pass
func boredom():
	pass
