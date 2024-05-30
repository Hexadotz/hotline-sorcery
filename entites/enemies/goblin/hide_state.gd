extends Node

@export var parent: Goblin
@onready var hide_places: Array[Node] = get_tree().get_nodes_in_group("hiding_spot")

var location: Vector2 =  Vector2.ZERO
var location_acquired: bool = false
#-------------------------------------------#
func _ready() -> void:
	pass

#TODO: fix this as the goblin freaks out since he picks a place to go to evrey frame
func hide() -> void:
	if hide_places.size() != 0:
		#pick a random spot on the map (the spots are predefined)
		if !location_acquired:
			location = hide_places.pick_random().global_position
			location_acquired = true
		
		#once we have a place to go to, well go to it
		parent.move_state.move_to(location)
		
		#once we reach our hiding spot set the state to panic
		parent.nav_agent.connect("target_reached" , func(): parent.set_state(parent.STATES.PANIC))
	else:
		parent.set_state(parent.STATES.PANIC)
