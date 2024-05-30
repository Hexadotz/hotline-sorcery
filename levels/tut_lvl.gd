extends Node2D


signal level_started
#--------------------------------------------------------#
func _ready() -> void:
	level_started.emit()
