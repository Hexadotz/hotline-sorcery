extends Node

@export var parent: Goblin
var knocked_back: bool = false
#----------------------------------------------------------#
func knockback(direction: Vector2) -> void:
	if !knocked_back:
		parent.velocity = Vector2.ZERO
		parent.animation.play("knock_back")
		parent.animation.connect("animation_looped", func(): parent.animation.stop())
		
		parent.velocity = direction * 80
		
		knocked_back = true
		$Timer.start()
	else:
		parent.velocity = lerp(parent.velocity, Vector2.ZERO, parent.ass_firction * get_physics_process_delta_time())

func _on_timer_timeout() -> void:
	parent.set_state(parent.STATES.CHASE)
	knocked_back = false
