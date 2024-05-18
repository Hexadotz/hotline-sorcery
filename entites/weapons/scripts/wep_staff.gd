extends Node2D

@export var projectile: PackedScene
@export var fire_cooldown: float = 0.1
@export var speed: float = 200.0

@onready var animation: AnimatedSprite2D = $staff
@onready var spawn_point: Node2D = $staff/muzzle
@onready var cast_cooldown: Timer = $"fire rater"
@onready var player: PlayerScript = get_tree().get_nodes_in_group("player")[0]

var can_cast: bool = true
var active: bool = true
#----------------------------------------------#
func _ready() -> void:
	#setup the timer node
	cast_cooldown.wait_time = fire_cooldown

func _physics_process(_delta: float) -> void:
	if active:
		if Input.is_action_pressed("fire"):
			if can_cast:
				animation.play("firing")
				#instancate the projectile set its start position set it's direction times speed then spawn it
				var projectile_inst: RigidBody2D = projectile.instantiate()
				projectile_inst.prepare_proj(player, spawn_point.global_position, get_global_mouse_position(), speed)
				spawn_point.add_child(projectile_inst)
				#after we shoot give a small cooldown (this is the firerate)
				cast_cooldown.start()
				can_cast = false
		else:
			animation.stop()

#allow shooting again after the shoot colldown
func _on_fire_rater_timeout() -> void:
	can_cast = true
