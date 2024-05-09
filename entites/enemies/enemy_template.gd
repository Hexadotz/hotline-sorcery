extends CharacterBody2D

var health: float = 20.0
@onready var player: PlayerScript = get_tree().get_nodes_in_group("player")[0]
@onready var cur_scene:= get_tree().get_current_scene()
@onready var blood: PackedScene = preload("res://misc/blood_particle.tscn")
#----------------------------------------------------------#
func _physics_process(delta: float) -> void:
	pass

func on_hit(dmg: float) -> void:
	health -= dmg
	var blood_ins: CPUParticles2D = blood.instantiate()
	blood_ins.global_position = global_position
	#FIXME: still having problems with the rotation of the
	blood_ins.rotation = global_position.angle_to_point(player.global_position)
	cur_scene.add_child(blood_ins)
	print(health)
	if health < 0:
		queue_free()
