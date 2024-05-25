extends Node2D

@export_flags_2d_physics var off_layer: int
@export_flags_2d_physics var on_layer: int

@onready var floor_A: TileMap = $"Floor A/FloorA"
@onready var floor_B: TileMap = $"Floor B/FloorB"
@onready var floor_C: TileMap = $"Floor C/FloorC"
#----------------------------------------------------------#
func _ready() -> void:
	pass
