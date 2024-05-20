extends StaticBody2D

@onready var particles: GPUParticles2D = $Window_bits
#------------------------------------------------#
func _ready() -> void:
	GlobalVariables.window_list.append(self.get_rid())
	particles.emitting = false

func shatter() -> void:
	#print("window shot")
	particles.emitting = true
	$AudioSFX.play()
	$Timer.start()

func _on_timer_timeout() -> void:
	particles.speed_scale = 0
