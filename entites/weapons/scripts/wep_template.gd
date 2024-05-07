extends RigidBody2D

@export var player: PlayerScript

@export var throw_strength: float = 250.0
var is_thrown: bool = false
#-----------------------------------------------------------#
func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	if is_thrown:
		#top_level = true
		pass
	if Input.is_action_just_pressed("drop-pickup") and !is_thrown:
		linear_velocity = player.looking_at_direction() * throw_strength
