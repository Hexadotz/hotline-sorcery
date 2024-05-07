extends Node2D


@export var fire_cooldown: float = 0.1
@export var speed: float = 200.0

@export var projectile: PackedScene
@onready var spawn_point: Node2D = $placeholder/muzzle
@onready var cast_cooldown: Timer = $"fire rater"
@onready var player: PlayerScript = get_parent().get_parent()

var projectile_inst: RigidBody2D
var can_cast: bool = true
#----------------------------------------------#
func _ready() -> void:
	#setup the timer node
	cast_cooldown.wait_time = fire_cooldown

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if can_cast:
			#instancate the projectile set its start position set it's direction times speed then spawn it
			projectile_inst = projectile.instantiate()
			projectile_inst.global_position = spawn_point.global_position
			var direction: Vector2 = player.global_position.direction_to(get_global_mouse_position())
			projectile_inst.linear_velocity = direction * (speed + player.speed)
			projectile_inst.rotation = player.rotation
			spawn_point.add_child(projectile_inst)
			#after we shoot give a small cooldown (this is the firerate)
			cast_cooldown.start()
			can_cast = false

#allow shooting again after the shoot colldown
func _on_fire_rater_timeout() -> void:
	can_cast = true
