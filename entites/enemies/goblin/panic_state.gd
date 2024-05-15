extends Node

@export var parent: Goblin

var look_dir: Vector2 = Vector2.ZERO
var change_rotation: bool = false
var to_angle: float = 0.0
#-------------------------------------------------------#
func panic() -> void:
	parent.velocity = Vector2.ZERO
	parent.animation.play("idle")
	if !change_rotation:
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		look_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))
		
		to_angle = parent.global_position.angle_to(look_dir.normalized())
		change_rotation = true
		$look_cooldown.start()
	
	#print(to_angle)
	parent.rotation = lerp_angle(parent.rotation, to_angle, 5 * get_physics_process_delta_time())

func _on_look_cooldown_timeout() -> void:
	change_rotation = false
