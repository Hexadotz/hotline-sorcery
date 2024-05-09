extends Node2D

@onready var debugger: DebuggerOverlay = $Debug_overlay
#----------------------------------------------------#
func _ready() -> void:
	debugger.add_stats("velocity", "player", "", "velocity")
	debugger.add_stats("--mouse")
	debugger.add_stats("mouse position", "player", "", "mouse_pos")
	debugger.add_stats("cam offset", "player", "Camera2D", "offset")
	debugger.add_stats("--weapons")
	debugger.add_stats("wep linear velocity", "wep_template", "", "linear_velocity")
