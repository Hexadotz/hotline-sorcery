class_name Goblin extends CharacterBody2D

@export_group("node refrences")
@export var nav_agent: NavigationAgent2D
@export var animation: AnimatedSprite2D
@export var sight_area: Area2D
@export var body: CollisionShape2D
@export_subgroup("state refrences")
@export var move_state: Node
@export var attack_state: Node2D
@export var hide_state: Node
@export var panic_state: Node
@export_group("floats")
@export_range(25.0, 50, 0.1) var attack_distance: float = 30
@export var detection_range: float = 100 ##the distance the enemy can look too
@export var detection_gap: float = 40.0 ##how wide the view

@onready var player: PlayerScript = GlobalVariables.player
@onready var cur_scene:= get_tree().get_current_scene()
@onready var blood: PackedScene = preload("res://misc/blood_particle.tscn")

var direction: Vector2 = Vector2.ZERO
var speed: float = 200
var health: float = 20.0

enum STATES{
	IDLE,		#0
	CHASE,		#1
	PANIC,		#2
	ATTACK,		#3
	KNOCKBACK,	#4
	HIDING,		#5
	DEATH		#6
}
var previous_st: STATES = STATES.IDLE
var current_st: STATES = STATES.IDLE

#WIP
var weapon_memory: Array[Weapon] = []
#var node_list: Array[Node2D] = get_overlapping_bodies()
#----------------------------------------------------------#
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	_state_machine()
	move_and_slide()
	
	if weapon_memory.size() > 0:
		print("wepons:", weapon_memory)

#the base state machine 
func _state_machine() -> void:
	match current_st:
		STATES.IDLE:
			animation.play("idle")
			velocity = Vector2.ZERO
			if health <= 10:
				set_state(STATES.HIDING)
		
		STATES.CHASE:
			move_state.move(player.global_position)
			
			#if the hostile is close enough to the player attack
			if !player.IS_DEAD:
				if global_position.distance_to(player.global_position) < attack_distance:
					set_state(STATES.ATTACK)
			else:
				#if someone killed the player don't bother chasing a dead man
				set_state(STATES.IDLE)
			
		STATES.PANIC:
			panic_state.panic()
		
		STATES.ATTACK:
			attack_state.attack()
			
		STATES.KNOCKBACK:
			animation.play("knockback")
		
		STATES.HIDING:
			hide_state.hide()
		
		STATES.DEATH:
			die(last_shot_dir)

func set_state(new_st: STATES) -> void:
	previous_st = current_st
	current_st = new_st

var last_shot_dir: Vector2 = Vector2.ZERO
func on_hit(dmg: float, hit_dir: Vector2) -> void:
	health -= dmg
	last_shot_dir = hit_dir
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
		set_state(STATES.DEATH)

var ass_firction: float = 5.0
var ded: bool = false
func die(dir: Vector2) -> void:
	animation.play("death")
	if !ded:
		velocity = dir * 100
		ded = true
	
	velocity = lerp(velocity, Vector2.ZERO, ass_firction * get_physics_process_delta_time())
	
	sight_area.monitoring = false
	if velocity.length() < 10:
		body.disabled = true

func _knockback() -> void:
	pass
