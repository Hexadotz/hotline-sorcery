extends Node2D

@export var blast_zone: Area2D
@export var particles: GPUParticles2D
@export var part_trail: GPUParticles2D
@export var anim: AnimationPlayer
@export var audio: AudioStreamPlayer2D

@onready var player = GlobalVariables.player 
@onready var blowup_sprite: PackedScene = preload("res://entites/objects/blow_decal.tscn")
#-----------------------------------------------#
func _ready() -> void:
	particles.emitting = true
	part_trail.emitting = true
	audio.play()
	anim.play("BOOM")
	$Timer.start()

func _physics_process(_delta: float) -> void:
	_BOOM()

var ray_paramters = PhysicsRayQueryParameters2D.new()
func _BOOM() -> void:
	var list: Array = blast_zone.get_overlapping_bodies()
	#print(list)
	for enemy: Node2D in list:
		if enemy.is_in_group("enemy"):
			ray_paramters.from = global_position
			ray_paramters.to = enemy.global_position
			
			var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(ray_paramters)
			
			if result.has("collider"):
				if result["collider"].has_method("on_hit"):
					result["collider"].on_hit(200, global_position.direction_to(enemy.global_position), "burn")
		
		elif enemy.is_in_group("player"):
			ray_paramters.from = global_position
			ray_paramters.to = enemy.global_position
			
			var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(ray_paramters)
			
			if result.has("collider"):
				if result["collider"].has_method("death"):
					result["collider"].death(global_position.direction_to(enemy.global_position))
		
		elif enemy.is_in_group("boom"):
			enemy.blow_up()
	
	if blowup_sprite:
		var decal: Sprite2D = blowup_sprite.instantiate()
		decal.global_position = global_position
		
		get_tree().current_scene.add_child(decal)

func _on_timer_timeout() -> void:
	queue_free()

func _on_shockwave_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "BOOM":
		$shockwave_shadder.hide()
