extends Node

@export var parent: Goblin

#------------------------------------------------------------#
#NOTE: the bastard can steal the club from your hand and kill you with it
func look_for_weapon() -> void:
	if parent.weapon_memory.size() != 0:
		var wep: Node2D = parent.weapon_memory.pick_random()
		if wep != null:
			parent.current_target = wep
			parent.move_state.move_to(parent.current_target.global_position)
			
			if parent.global_position.distance_to(parent.current_target.global_position) < parent.pickup_raduis:
				parent.pickup_weapon()
		else:
			parent.weapon_memory.remove_at(parent.weapon_memory.find(wep))
			parent.set_state(parent.STATES.HIDING)
		
	else:
		parent.set_state(parent.STATES.HIDING)
