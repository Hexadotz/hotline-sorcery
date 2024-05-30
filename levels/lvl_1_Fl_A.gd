extends Node2D

@export_flags_2d_physics var off_layer: int
@export_flags_2d_physics var on_layer: int


@onready var player = get_tree().current_scene.get_node("player")

@onready var floor_A: Node2D = $"Floor A/FloorA"
@onready var floor_B: Node2D = $"Floor B/FloorB"
@onready var floor_C: Node2D = $"Floor C/FloorC"

var cur_floor: int = 0

var level_clear: bool = false

var A_clear: bool = false
var A_clear_instant: bool = false

var B_clear: bool = false
var B_clear_instant: bool = false

var C_clear: bool = false
var C_clear_instant: bool = false

signal level_started
signal switched_floor
signal floor_cleared

var stunts: Array = []
#----------------------------------------------------------#
func _ready() -> void:
	level_started.emit()
	for x in get_tree().get_nodes_in_group("enemy"):
		x.connect("enemy_died", _check_floor_clear)
	cur_floor = 0

func _physics_process(_delta: float) -> void:
	A_clear = _is_floor_clear($"Floor A/enemies")
	B_clear = _is_floor_clear($"Floor B/enemies")
	C_clear = _is_floor_clear($"Floor C/enemies")
	
	level_clear = C_clear
	#print(A_clear)

func _is_floor_clear(entites: Node2D) -> bool:
	for x in entites.get_children():
		if x.is_in_group("enemy"):
			if not x.IS_DEAD:
				return false
	
	return true

func set_floor_light(value: bool) -> void:
	var lights: Array = $"Floor A/lights".get_children()
	lights.append_array($"Floor B/lights".get_children())
	lights.append_array($"Floor C/lights".get_children())
	
	for light in lights:
		if light is PointLight2D:
			light.enabled = value
			light.shadow_enabled = value

func _check_floor_clear() -> void:
	await get_tree().create_timer(0.1).timeout
	if A_clear and !A_clear_instant:
		player.UI.emit_signal("lvl_done")
		A_clear_instant = true
	elif B_clear and !B_clear_instant:
		player.UI.emit_signal("lvl_done")
		B_clear_instant = true
	elif C_clear: 
		player.UI.emit_signal("lvl_done", "balls")

#-----------------------Floor A----------------------------#
func _on_to_B_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if A_clear and not level_clear:
			cur_floor = 1
			
			emit_signal("switched_floor", $"Floor B/TO_A".global_position)

#-----------------------Floor B----------------------------#
func _on_BACK_TO_A_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_clear:
			cur_floor = 0
			
			emit_signal("switched_floor", $"Floor A/TO_B".global_position)

func _on_TO_C_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if B_clear and not level_clear:
			cur_floor = 2
			
			emit_signal("switched_floor", $"Floor C/TO_B".global_position)

#-----------------------Floor C----------------------------#
func _on_BACK_TO_B_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_clear:
			cur_floor = 1
			
			emit_signal("switched_floor", $"Floor B/TO_C".global_position)
