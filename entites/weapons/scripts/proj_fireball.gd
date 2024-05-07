extends RigidBody2D

@export var projectile_type: int

@onready var hitbox: ShapeCast2D = $hitbox
@onready var anim: AnimatedSprite2D = $Animation
@onready var line: Line2D = $Line2D
#NOTE: i need to get some sleep
#----------------------------------------------------------#
func _ready() -> void:
	#HACK: this is ugly and needs to be eradicated from existance (by that i mean the reference of the player)
	#what if the enemy pick up the staff? who the fuck is going to tell this ball where the player is
	hitbox.add_exception(get_parent().get_parent().get_parent().player)

func _physics_process(_delta: float) -> void:
	_draw_trail()
	
	if hitbox.is_colliding():
		#get the first collision that occures
		var collidier = hitbox.get_collider(0)
		#if its an enemy damage him and the destory itself if not well destroy itself as well 
		if collidier.is_in_group("enemy"):
			if collidier.has_method("got_hit"):
				collidier.got_hit()
				queue_free()
		else:
			queue_free()

@export var line_length: float = 10.0
var point_pos: Vector2 = Vector2.ZERO
#this function draws a trail effect behind the boolet
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
	

#if the bullet went far without colliding with anything destroy it for optimization
func _on_timer_timeout() -> void:
	queue_free()
