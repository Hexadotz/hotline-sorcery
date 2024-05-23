extends Node2D

@onready var debugger: DebuggerOverlay = $Debug_overlay
var path_interval: Array[Vector2] = []
#----------------------------------------------------#
func _ready() -> void:
	debugger.add_stats("velocity", "player", "", "velocity")
	debugger.add_stats("--mouse")
	debugger.add_stats("mouse position", "player", "", "mouse_pos")
	debugger.add_stats("cam offset", "player", "Camera2D", "offset")
	debugger.add_stats("--weapons")
	debugger.add_stats("wep linear velocity", "wep_template", "", "linear_velocity")
	debugger.add_stats("--enemy")
	debugger.add_stats("gob's current state", "goblin", "", "get_current_state")
	debugger.add_stats("gob's previous state", "goblin", "", "get_previous_state")
	debugger.add_stats("gob's velocity", "goblin3", "", "velocity")
	debugger.add_stats("gob's health", "goblin3", "", "health")

func _physics_process(_delta: float) -> void:
	#print($Door.rigid.linear_velocity.length())
	pass
