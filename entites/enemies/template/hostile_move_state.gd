extends Node

@export var parent: Goblin
#---------------------------------------------------------#

func move_to(target_pos: Vector2) -> void:
	parent.nav_agent.target_position = target_pos
	
	var next_point: Vector2 = parent.nav_agent.get_next_path_position()
	parent.direction = parent.global_position.direction_to(next_point)
	parent.velocity = parent.direction * parent.speed
	
	parent.animation.play("run")
	parent.look_at(next_point)
