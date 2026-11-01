extends CharacterBody2D
var speed = 175
var player_chase = false
var direction : Vector2

@onready var aim_pivot: Node2D = $aim_pivot
@onready var laser_gun: FireArm = $aim_pivot/LaserGun


@export var Goal: Node = null
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

@export var attack_range: float = 100.0
@export var retreat_range: float = 50.0
@export var preferred_range: float = 80.0


func _physics_process(delta: float) -> void:
	update_state()
	process_ai()

enum EnemyState {
	IDLE,
	APPROACH,
	ATTACK,
	RETREAT,
	SEARCH,
	DEATH
}

var state : EnemyState = EnemyState.IDLE

func update_state():
	aim_pivot.look_at(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance>attack_range:
		state = EnemyState.APPROACH
		
	elif distance<retreat_range:
		state = EnemyState.RETREAT
		
	else:
		state = EnemyState.ATTACK

func navigate_to_combat_position():
	var away_direction = player.global_position.direction_to(global_position)

	var target = player.global_position + away_direction * preferred_range

	navigation_agent_2d.target_position = target

	var next_point = navigation_agent_2d.get_next_path_position()
	var direction = global_position.direction_to(next_point)

	velocity = direction * speed
	move_and_slide()
	
func process_ai():
	match state:
		EnemyState.IDLE:
			idle()

		EnemyState.APPROACH:
			approach()

		EnemyState.ATTACK:
			attack()

		EnemyState.RETREAT:
			retreat()

		EnemyState.SEARCH:
			search()
			
		EnemyState.DEATH:
			death()

func idle():
	pass
	
func approach():
	navigate_to_combat_position()
	
func attack():
	velocity = Vector2.ZERO
	move_and_slide()
	laser_gun.attack()
	
	
	
func retreat():
	navigate_to_combat_position()
	
func search():
	pass
	
func death():
	pass
