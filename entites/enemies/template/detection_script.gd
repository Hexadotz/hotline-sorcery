extends Area2D

@export var pref_weapon: String = ""

@onready var parent: Node2D = get_parent()
@onready var poly_col: CollisionPolygon2D = $CollisionPolygon2D

#-----------------------------------------------------#
func _ready() -> void:
	_configure_view_radius()

func _configure_view_radius() -> void:
	var sight_shape: PackedVector2Array = []
	sight_shape.append(Vector2(0,0))
	sight_shape.append(Vector2(parent.detection_range, parent.detection_gap))
	sight_shape.append(Vector2(parent.detection_range, -parent.detection_gap))
	
	poly_col.polygon = sight_shape

func _physics_process(_delta: float) -> void:
	if parent.current_st == parent.STATES.DEATH:
		monitoring = false
	
	if monitoring:
		var node_list: Array[Node2D] = get_overlapping_bodies()
		if node_list.size() == 1 and !node_list[0].IS_DEAD:
			if is_on_sight(node_list) and parent.current_st not in [parent.STATES.DEATH, parent.STATES.ATTACK]:
				parent.set_state(parent.STATES.CHASE)
	else:
		poly_col.disabled = true

#check the enemy's line of sight to prevent the enemy from chasing the player even through he is behind a wall
var ray_parm = PhysicsRayQueryParameters2D.new()
func is_on_sight(list: Array) -> bool:
	if list[0].is_in_group("player"):
		#setting up the ray paramaters
		ray_parm.from = parent.global_position
		ray_parm.to = list[0].global_position
		
		var results: Dictionary = get_world_2d().direct_space_state.intersect_ray(ray_parm)
		#this is made to prevent the game from ccrashing due to the enemy getting too close to the player the raycast fail to detect anyting
		if results.has("collider"):
			return results["collider"] == parent.player
		else: 
			return false
	return false

func _backup_plan(node) -> void:
		#if the enemy sees a weapon while moving it holds
		if node.is_in_group("weapon") and node.is_in_group(pref_weapon):
			if parent.get("weapon_memory") != null:
				parent.weapon_memory.append(node)
