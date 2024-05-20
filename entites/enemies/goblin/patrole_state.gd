extends Node

@export var parent: Goblin

var PICKED_PATH: bool = false
#-------------------------------------------------------#

var patrol_loc: Node2D 
func patrol() -> void:
	var pathes: Array = get_tree().get_nodes_in_group("patrol_path")
	
	if !PICKED_PATH:
		patrol_loc = pathes.pick_random() if parent.patrol_path == null else parent.patrol_path
		PICKED_PATH = true
	
	if patrol_loc != null:
		parent.move_state.move_to(patrol_loc.global_position)
	else:
		parent.set_state(parent.STATES.PANIC)
