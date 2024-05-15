extends Node

@export var player: PlayerScript

@export var walk_speed: float = 100
@export var run_speed: float = 200
#-------------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	_input_process()
	
	#adding walking ability
	if Input.is_action_pressed("walk"):
		player.speed = walk_speed  
	else:
		player.speed = run_speed
	
	player.target_dir = player.direction * player.speed

func _input_process() -> void: 
	#reset the direction so we don't keep going in a direction when we let go of a movement key
	player.direction = Vector2.ZERO
	
	#get the direction we're heading towards
	player.direction.y = Input.get_axis("forward", "backward")
	player.direction.x = Input.get_axis("left", "right")
	
	#normalize the vector so we don't go faster when walking diagonally
	player.direction = player.direction.normalized()
