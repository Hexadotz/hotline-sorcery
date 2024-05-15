extends Node

@export var parent: Node2D = get_parent()
#---------------------------------------------------------#

func move(target_pos: Vector2) -> void:
	parent.nav_agent.target_position = target_pos
	
	var next_point: Vector2 = parent.nav_agent.get_next_path_position()
	#var look_to: float = parent.to_local(target_pos).angle_to(parent.to_local(target_pos.normalized()))
	#print(rad_to_deg(look_to))
	#parent.rotation = lerp_angle(parent.rotation, look_to, 20 * get_physics_process_delta_time())
	
	#if parent.eye_sight.is_on_sight():
		#parent.look_at(target_pos)
	#else:
	parent.look_at(next_point)
	
	parent.direction = parent.global_position.direction_to(next_point)
	
	parent.velocity = parent.direction * parent.speed
	
	parent.animation.play("run")
