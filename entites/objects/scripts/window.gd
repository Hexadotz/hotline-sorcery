extends StaticBody2D

@onready var particles: GPUParticles2D = $Window_bits
var broken: bool = false
#------------------------------------------------#
func _ready() -> void:
	GlobalVariables.window_list.append(self.get_rid())
	particles.emitting = false

func shatter() -> void:
	particles.emitting = true
	if !broken:
		$AudioSFX.play()
		$Timer.start()
		broken = true

func _on_timer_timeout() -> void:
	particles.speed_scale = 0
