extends RigidBody2D

@export var trail_color: Color = Color(1, 1, 1, 1)
@export var line_length: float = 10.0 #the length of the trail


@onready var player: PlayerScript = GlobalVariables.player
@onready var anim: AnimatedSprite2D = $Animation
@onready var hitbox: Area2D = $hurtbox
@onready var line: Line2D = $trail_effect

var damage: float = 5
var point_pos: Vector2 = Vector2.ZERO #the point the line is going to start from

enum TYPE{
	MISSLE,
	FIREBALL,
}
var proj_type: TYPE = TYPE.MISSLE
const MISSLE_COLOR: Color = Color(0, 0.452, 0.575)
const FIREBALL_COLOR: Color = Color(1, 0.355, 0.192)
#----------------------------------------------------------#
func _ready() -> void:
	line.modulate = trail_color

func setup_projectile() -> void:
	pass

func _physics_process(_delta: float) -> void:
	_draw_trail()
	_set_type()

func _set_type() -> void:
	match proj_type:
		TYPE.MISSLE:
			anim.play("missile")
			line.modulate = MISSLE_COLOR
		TYPE.FIREBALL:
			anim.play("fireball")
			line.modulate = FIREBALL_COLOR

#this function draws a trail effect behind the boolets
func _draw_trail() -> void:
	#keep the line effect from inhereting the global position and rotation
	
	line.global_position = Vector2.ZERO
	line.global_rotation = 0
	
	#acquire the position
	point_pos = global_position
	
	#we add the start point
	line.add_point(point_pos)
	#the moment the line points becomes greater than line_length we start deleteing the fist ones
	while line.get_point_count() > line_length:
		line.remove_point(0)

func prepare_proj(shooter: Node2D, glob_pos: Vector2, to_vec: Vector2, speed: float) -> void:
	var direction: Vector2 = glob_pos.direction_to(to_vec)
	global_position = glob_pos
	linear_velocity = direction * (speed + shooter.speed)
	rotation = shooter.rotation

#if the bullet went far without colliding with anything destroy it for optimization
func _on_timer_timeout() -> void:
	queue_free()

func _on_hirtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("on_hit"):
			body.on_hit(damage, linear_velocity.normalized())
			queue_free()
	elif body.is_in_group("window"):
		body.shatter()
	else:
		queue_free()
