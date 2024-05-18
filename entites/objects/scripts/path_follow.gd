extends PathFollow2D

@export_range(0.0, 0.5, 0.001) var patrole_speed: float = 0.25

#-------------------------------------------------#
func _physics_process(delta: float) -> void:
	progress_ratio += patrole_speed * delta
