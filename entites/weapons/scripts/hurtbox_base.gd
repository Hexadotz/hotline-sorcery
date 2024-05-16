extends Area2D

@export var parent: RigidBody2D
@export var throw_box: CollisionShape2D 
@export var swing_box: CollisionShape2D
#------------------------------------------#
func _ready() -> void:
	swing_box.disabled = true
	throw_box.disabled = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if parent.FATAL_THROW:
			if parent.linear_velocity.length() > (parent.throw_strength * 0.7):
				body.on_hit(parent.throw_strength, parent.linear_velocity.normalized())
				parent.linear_velocity = Vector2.ZERO
		else:
			if !parent.active:
				body.last_shot_dir = parent.linear_velocity.normalized()
				body.set_state(body.STATES.KNOCKBACK)
				parent.linear_velocity = Vector2.ZERO
				
				#disable the collision boxes at the end of a frame
				throw_box.set_deferred("disabled", true)
				parent.collision_box.set_deferred("disabled", false)
				parent.set_deferred("freeze", true)
