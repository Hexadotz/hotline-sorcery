extends Node2D

@export var parent: Goblin 
@export var damage_area: Area2D
@export var swing_audio: AudioStreamPlayer

#-----------------------------------------------#
func _ready() -> void:
	damage_area.monitoring = false

func attack() -> void:
	damage_area.monitoring = true
	parent.velocity = Vector2.ZERO
	parent.animation.play("attack")
	
	if !swing_audio.is_playing():
		swing_audio.play()
	
	#use a lambda, if the player is dead put the enemy on a idle state, otherewise kiil chasing his ass
	var is_dead = func():
		if !parent.player.IS_DEAD:
			parent.set_state(parent.STATES.CHASE)
		else:
			parent.set_state(parent.STATES.IDLE)
	
	parent.animation.connect("animation_finished" , is_dead)

func _on_damage_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !body.IS_DEAD and !body.INVINSIBLE:
			body.death(global_position.direction_to(body.global_position))
