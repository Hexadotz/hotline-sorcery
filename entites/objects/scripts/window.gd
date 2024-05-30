@tool
extends StaticBody2D

@export var length: int = 60

@onready var particles: GPUParticles2D = $Window_bits
var broken: bool = false
#------------------------------------------------#
func _ready() -> void:
	if not Engine.is_editor_hint():
		GlobalVariables.window_list.append(self.get_rid())
	particles.emitting = false

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$CollisionShape2D.shape.size.y = length

func shatter(target: Vector2) -> void:
	var angle: float = particles.global_position.angle_to(target)
	particles.global_rotation = (angle + 90)
	
	particles.emitting = true
	if !broken:
		$AudioSFX.play()
		$Timer.start()
		broken = true

func _on_timer_timeout() -> void:
	particles.speed_scale = 0
