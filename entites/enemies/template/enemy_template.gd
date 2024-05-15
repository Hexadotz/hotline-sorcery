class_name EnemyClass extends CharacterBody2D

@export var nav_agent: NavigationAgent2D
@export var sight_area: Area2D
@export var detection_range: float = 100 ##the distance the enemy can look too
@export var detection_gap: float = 40.0 ##how wide the view


@onready var player: PlayerScript = get_tree().get_nodes_in_group("player")[0]
@onready var cur_scene:= get_tree().get_current_scene()
@onready var blood: PackedScene = preload("res://misc/blood_particle.tscn")

var direction: Vector2 = Vector2.ZERO
var speed: float = 200
var health: float = 20.0

enum STATES{
	IDLE,
	CHASE,
	PANIC,
	ATTACK,
	DEATH
}
var previous_st: STATES = STATES.IDLE
var current_st: STATES = STATES.IDLE

var weapon_memory: Array[Weapon] = []
#----------------------------------------------------------#
func _ready() -> void:
	#print(player)
	for node in get_children():
		#pass the player reference to childrens
		if node.get("player") != null:
			node.player = player
		#passing the base enemy reference to childrens
		if node.get("parent") != null:
			node.parent = self

func _physics_process(_delta: float) -> void:
	_state_machine()

#the base state machine 
func _state_machine() -> void:
	match current_st:
		STATES.IDLE:
			pass
		STATES.CHASE:
			move(player.global_position)
		STATES.PANIC:
			pass
		STATES.ATTACK:
			pass
		STATES.DEATH:
			pass

func set_state(new_st: STATES) -> void:
	previous_st = current_st
	current_st = new_st

func move(target_pos: Vector2) -> void:
	look_at(target_pos)
	#look_at(nav_agent.get_next_path_position())
	nav_agent.target_position = target_pos
	direction = global_position.direction_to(nav_agent.get_next_path_position())
	
	velocity = direction * speed
	
	move_and_slide()

func on_hit(dmg: float) -> void:
	health -= dmg
	var blood_ins: GPUParticles2D = blood.instantiate()
	blood_ins.global_position = global_position
	
	#convert player direction from Vector2 to Vector3 because the godot developers are fucking morons
	var dir: Vector2 = global_position.direction_to(player.global_position)
	var blood_dir: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, Vector2(dir.x, -dir.y).angle())
	blood_ins.process_material.direction = -blood_dir
	
	#leaving this here in case the method above bite me in the ass later
	#blood_ins.rotation = -abs(global_position.angle_to_point(player.global_position))
	
	cur_scene.add_child(blood_ins)
	
	if health < 0:
		queue_free()

