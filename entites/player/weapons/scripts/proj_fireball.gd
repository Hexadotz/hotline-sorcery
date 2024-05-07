extends RigidBody2D

@onready var hitbox: ShapeCast2D = $hitbox
#NOTE: i need to get some sleep
#----------------------------------------------------------#
func _ready() -> void:
	#HACK: this is ugly and needs to be eradicated from existance (by that i mean the reference of the player)
	#what if the enemy pick up the mage? who the fuck is going to tell this ball where the player is
	hitbox.add_exception(get_parent().get_parent().get_parent().player)

func _physics_process(delta: float) -> void:
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

#if the bullet went far without colliding with anything destroy it for optimization
func _on_timer_timeout() -> void:
	queue_free()
