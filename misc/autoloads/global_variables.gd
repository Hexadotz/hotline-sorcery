extends Node

@onready var player: PlayerScript 
@onready var player_staff: Staff
@onready var cur_scene: = get_tree().get_current_scene()

var window_list: Array[RID] = []

#-------------------------------------------------#
var show_fps: bool = false
var disable_lights: bool = false
#-----------------------------------------------------------#
func _ready() -> void:
	pass 


