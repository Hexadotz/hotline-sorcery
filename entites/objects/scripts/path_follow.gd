extends PathFollow2D

@export var type: TYPE
@export_range(0.0, 0.5, 0.001) var patrole_speed: float = 0.25

enum TYPE {
	CIRCLAR,
	LINEAR
}
var direction: int = 1
#-------------------------------------------------#
func _physics_process(delta: float) -> void:
	if type == TYPE.CIRCLAR:
		loop = true
		progress_ratio += patrole_speed * delta
	else:
		loop = false
		progress_ratio += (patrole_speed * direction) * delta
		if progress_ratio >= 1 or progress_ratio <= 0:
			direction  *= -1
		
