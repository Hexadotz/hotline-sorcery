extends Node

@export var parent: Goblin

#------------------------------------------------------------#
#NOTE: the bastard can steal the club from your hand and kill you with it
func look_for_weapon() -> void:
	if parent.weapon_memory.size() != 0:
		var min_dist: float = parent.global_position.distance_to(parent.weapon_memory[0].global_position)
		parent.current_target = parent.weapon_memory[0]
		for wep in parent.weapon_memory:
			if parent.global_position.distance_to(wep.global_position) < min_dist:
				min_dist = parent.global_position.distance_to(wep.global_position)
				parent.current_target = wep
	else:
		parent.set_state(parent.STATES.HIDING)
	
	parent.move_state.move_to(parent.current_target.global_position)
	#if the enemy is close enough pickup a weapon
	if parent.global_position.distance_to(parent.current_target.global_position) < parent.pickup_raduis:
		parent.pickup_weapon()
