@tool
extends PinJoint2D

@export var size: Vector2i = Vector2i(59, 8)

@onready var knockback_collision: CollisionShape2D = $door_physics/Area2D/CollisionShape2D
@onready var knockout_area: Area2D = $door_physics/Area2D

@onready var door_collision: CollisionShape2D = $door_physics/CollisionShape2D
@onready var rigid: RigidBody2D = $door_physics
#---------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	#NOTE: 1 px in collision shape = 0.5 pixel in position
	door_collision.shape.size = size
	door_collision.position.x = float(size.x) / 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if rigid.linear_velocity.length() > 200:
		if body.is_in_group("enemy"):
			body.last_shot_dir = rigid.linear_velocity.normalized()
			body.set_state(body.STATES.KNOCKBACK)
