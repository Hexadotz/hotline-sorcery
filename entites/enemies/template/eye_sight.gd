extends Node2D
 
@export var pref_weapon: String = ""
@export var player_sight: Area2D
@export var wep_sight_area: Area2D
 
@onready var parent: Goblin = get_parent()
@onready var player_poly_col: CollisionPolygon2D = $player/CollisionPolygon2D
@onready var wep_poly_col: CollisionPolygon2D = $weapon/CollisionPolygon2D

#-----------------------------------------------------#
func _ready() -> void:
	_configure_view_radius()
 
func _configure_view_radius() -> void:
	var sight_shape: PackedVector2Array = []
	sight_shape.append(Vector2(0,0))
	sight_shape.append(Vector2(parent.detection_range, parent.detection_gap))
	sight_shape.append(Vector2(parent.detection_range, -parent.detection_gap))
 
	#fuck my whole life
	wep_poly_col.polygon = sight_shape
	player_poly_col.polygon = sight_shape
 
func _physics_process(_delta: float) -> void:
	if parent.current_st == parent.STATES.DEATH:
		player_sight.monitoring = false
 
	if player_sight.monitoring:
		#remember weapons
		if wep_sight_area.has_overlapping_bodies():
			_remember_weapons(wep_sight_area.get_overlapping_bodies())
 
		if is_on_sight() and !parent.player.IS_DEAD and parent.ARMED:
			if parent.current_st not in [parent.STATES.DEATH, parent.STATES.ATTACK, parent.STATES.KNOCKBACK, parent.STATES.HIDING]:
				parent.set_state(parent.STATES.CHASE)
	else:
		player_poly_col.disabled = true
 
func _remember_weapons(list: Array) -> void:
	for wep in list:
		if wep.is_in_group("weapon") and parent.weapon_memory.find(wep) == -1:
			parent.weapon_memory.append(wep)
 
#check the enemy's line of sight to prevent the enemy from chasing the player even through he is behind a wall
var ray_parm = PhysicsRayQueryParameters2D.new()
func is_on_sight() -> bool:
	var player: Array[Node2D] = player_sight.get_overlapping_bodies()
	if !player.is_empty():
		#setting up the ray paramaters
		ray_parm.from = parent.global_position
		ray_parm.to = player[0].global_position
		ray_parm.exclude = GlobalVariables.window_list
		
		var results: Dictionary = get_world_2d().direct_space_state.intersect_ray(ray_parm)
		#this is made to prevent the game from ccrashing due to the enemy getting too close to the player the raycast fail to detect anyting
		if results.has("collider"):
			return results["collider"] == parent.player
		else: 
			return false
	return false
