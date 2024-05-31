extends StaticBody2D

@export var combussin: bool = false
@onready var cur_scene = get_tree().current_scene
@onready var boom: PackedScene = preload("res://entites/objects/explostion.tscn")
#--------------------------------------------------------#
func blow_up() -> void:
	if !combussin:
		return
	else:
		var boomshine: Node2D = boom.instantiate()
		boomshine.global_position = global_position
		
		cur_scene.call_deferred("add_child", boomshine)
		cur_scene.booms += 1
		queue_free()
